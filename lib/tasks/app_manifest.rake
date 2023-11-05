namespace :manifest do
  desc 'Generate and update app_manifest.json from app_manifest_template.json'
  task generate: :environment do
    require 'json'
    require 'dotenv'

    # Load environment variables from .env file in the project root directory
    Dotenv.load(File.join(Rails.root, '.env'))

    # Read the template JSON file from the project root
    template_file = File.read(File.join(Rails.root, 'app_manifest_template.json'))

    # Perform global replacements for SERVER_HOST_NAME and SLACK_CLIENT_ID
    updated_content = template_file
      .gsub('SERVER_HOST_NAME', ENV['SERVER_HOST_NAME'])
      .gsub('SLACK_CLIENT_ID', ENV['SLACK_CLIENT_ID'])

    # Write the updated JSON to app_manifest.json in the project root
    File.open(File.join(Rails.root, 'app_manifest.json'), 'w') do |file|
      file.write(updated_content)
    end

    puts 'app_manifest.json has been generated and updated.'
  end
end
