require_relative '../questionnaire'

RSpec.describe 'Questionnaire' do
  describe '#do_prompt' do
    let(:store) { PStore.new(STORE_NAME) }

    before do
      allow_any_instance_of(Object).to receive(:prompt_question).and_return('yes')
    end

    it 'should prompt all questions and record responses' do
      expect(store).to receive(:transaction).exactly(QUESTIONS.size + 1).times
      do_prompt(store)
    end

    it 'should calculate and display ratings' do
      expect { do_prompt(store) }.to output(/Your rating for this run: \d+.\d+%\nAverage rating over all runs: \d+.\d+%/).to_stdout
    end
  end

  describe '#do_report' do
    let(:store) { PStore.new(STORE_NAME) }

    context 'when there is survey data available' do
      before do
        store.transaction do
          store[:total_runs] = 5
          store[:total_yes_answers] = 12
        end
      end

      it 'should display the total runs and average rating' do
        expect { do_report(store) }.to output(/Total Runs: 5\nAverage rating over all runs: 48.0%/).to_stdout
      end
    end

    context 'when there is no survey data available' do
      before do
        store.transaction do
          store[:total_runs] = nil
          store[:total_yes_answers] = nil
        end
      end

      it 'should display appropriate message' do
        expect { do_report(store) }.to output("No survey data available.\n").to_stdout
      end
    end
  end
end
