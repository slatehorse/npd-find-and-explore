# frozen_string_literal: true

require_relative 'sheet'

module DfEDataTables
  module DataElementParsers
    class ScPupil < Sheet
    private

      def regex
        /SC_Pupil#{YEARS_REGEX}/
      end
    end
  end
end