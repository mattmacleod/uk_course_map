class UnistatsJoblist < ActiveRecord::Base
  establish_connection(:unistats)
  set_table_name :jobs

  def self.import!

    joblist = UnistatsJoblist.all.inject({}) #{ |acc,val| acc[val.ukprn.strip] = val.name; acc }

    self.all.each do |job|

      app_in = Jobs.find_or_create_by_recordId joblist.recordId

      app_in.attributes = {
        :name               => joblist[job.recordId.to_i],
        :job                => joblist[job.JOB.to_s],
        :percentageEmployed => joblist[job.PERC.to_i],
        :order              => joblist[job.ORDER.to_i]
      }

      app_in.save!

    end

  end

end
