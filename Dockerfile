# Use the official Ruby image as a base
FROM ruby:3.2.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Set up the app directory
WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

# Copy the application code
COPY . .

# Precompile assets for production using a dummy key
RUN SECRET_KEY_BASE=dummy_key RAILS_ENV=production bundle exec rake assets:precompile

# Expose the default Rails port
EXPOSE 3000

# Set environment variables for runtime
ENV RAILS_ENV=production

# Start the application
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
