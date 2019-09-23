module Moonshot
  module Commands
    class Delete < Moonshot::Command
      include ShowAllEventsOption

      self.usage = 'delete [options]'
      self.description = 'Delete an existing environment'

      def parser
        parser = super
        parser.on('--template-file=FILE', 'Override the path to the CloudFormation template.') do |v| # rubocop:disable LineLength
          Moonshot.config.template_file = v
        end
      end

      def execute
        controller.delete
      end
    end
  end
end
