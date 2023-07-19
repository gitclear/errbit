namespace :errbit do
  desc "Updates cached attributes on Problem"
  task problem_recache: :environment do
    ProblemRecacher.run
  end

  desc "Delete resolved errors from the database. (Useful for limited heroku databases)"
  task clear_resolved: :environment do
    require 'resolved_problem_clearer'
    puts "=== Cleared #{ResolvedProblemClearer.new.execute} resolved errors from the database."
  end

  desc "Delete old errors from the database. (Useful for limited heroku databases)"
  task clear_outdated: :environment do
    require 'outdated_problem_clearer'
    if Errbit::Config.notice_deprecation_days.present?
      puts "=== Cleared #{OutdatedProblemClearer.new.execute} outdated errors from the database."
    else
      puts "=== ERRBIT_PROBLEM_DESTROY_AFTER_DAYS not set. Old problems will not be destroyed."
    end
  end


  desc "Delete old errors from the database."
    task :clear_old => :environment do
      require 'old_problem_clearer'
      puts "=== Cleared #{OldProblemClearer.new.execute} old errors from the database."
    end

    desc "Regenerate fingerprints"
    task :regenerate_fingerprints => :environment do
      puts "Regenerating Err fingerprints"
      Err.create_indexes
      Err.all.each do |err|
        next if err.notices.count == 0 || err.app.nil?

        fingerprint = ErrorReport.fingerprint_strategy.generate(err.notices.first, err.app.api_key)
        next if fingerprint == err.fingerprint

        # Migrate notices to the new err and remove the old err
        new_err = err.app.find_or_create_err!(
          :error_class => err.problem.error_class,
          :environment => err.problem.environment,
          :fingerprint => fingerprint
        )

        err.notices.each do |notice|
          notice.update_attribute(:err_id, new_err.id)
        end

        err.problem.update_attributes(:notices_count => err.problem.notices.count)
        if err.problem.notices_count == 0
          err.problem.destroy
        end

        err.destroy
      end
    end
  end

  desc "Updates cached attributes on Problem"
  task problem_recache: :environment do
    ProblemRecacher.run
  end

  desc "Regenerate fingerprints"
  task notice_refingerprint: :environment do
    NoticeRefingerprinter.run
    ProblemRecacher.run
  end

  desc "Remove notices in batch"
  task :notices_delete, [:problem_id] => [:environment] do
    BATCH_SIZE = 1000
    if args[:problem_id]
      item_count = Problem.find(args[:problem_id]).notices.count
      removed_count = 0
      puts "Notices to remove: #{item_count}"
      while item_count > 0
        Problem.find(args[:problem_id]).notices.limit(BATCH_SIZE).each do |notice|
          notice.remove
          removed_count += 1
        end
        item_count -= BATCH_SIZE
        puts "Removed #{removed_count} notices"
      end
    end
  end
end
