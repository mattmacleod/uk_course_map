class UnistatsInstitution < ActiveRecord::Base
  establish_connection(:unistats)
  set_table_name :institution

  def self.import!

    ukprnmap = UnistatsUkprnmap.all.inject({}) { |acc,val| acc[val.ukprn.strip] = val.name; acc }

    self.all.each do |inst|

      app_in = Institution.find_or_create_by_ukprn inst.UKPRN

      country = {
        "XI" => "Wales",
        "XH" => "Scotland",
        "XG" => "Northern Ireland",
        "XF" => "England"
      }[inst.COUNTRY]

      cost = [inst.INSTLOWER.to_s, inst.INSTUPPER.to_s, inst.PRIVATELOWER.to_s, inst.PRIVATEUPPER.to_s].select(&:present?).map(&:to_i)
      cost = cost.empty? ? nil : cost.sum / cost.length

      app_in.attributes = {
        :name               => ukprnmap[inst.UKPRN.to_s],
        :unistats_id        => inst.recordId,
        :url_accommodation  => inst.ACCOMURL,
        :accommodation_cost => cost,
        :country            => country
      }

      app_in.save!

    end

  end

end
