# config/initializers/delayed_job_config.rb
Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 60
Delayed::Worker.max_attempts = 10
Delayed::Worker.max_run_time = 30.minutes
Delayed::Worker.delay_jobs = !Rails.env.test?

# Delay Priorities:
# 0 - Immediate/Urgent (eg, will be seen by user in-app asap)
# 10 - High Priority (eg, user needs asap outside of app, such as reset password email )
# 50 - Medium Priority (eg, user will need to be notified of results)
# 80 - Low Priority (eg, due to UX, user will not be aware of delay)
# 100 - Background (eg, needs to occur, but execution time is not important)
Delayed::Worker.default_priority = 50