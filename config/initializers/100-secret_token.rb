# frozen_string_literal: true

# Not fussed setting secret_token anymore, that is only required for
# backwards support of "seamless" upgrade from Rails 3.
# Discourse has shipped Rails 3 for a very long time.

# Check if the SECRET_KEY_BASE environment variable is set and fall back to GlobalSetting if needed.
Discourse::Application.config.secret_key_base = ENV['SECRET_KEY_BASE'] || GlobalSetting.safe_secret_key_base

# Debugging output to ensure the correct key is being used.
puts "Using SECRET_KEY_BASE: #{Discourse::Application.config.secret_key_base ? 'Set' : 'Not Set'}"
