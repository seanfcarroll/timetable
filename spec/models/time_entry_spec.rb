# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TimeEntry, type: :model do
  describe 'validations' do
    it 'require a user' do
      expect(subject).to have(1).error_on :user
      subject.user = build :user
      expect(subject).to have(0).errors_on :user
    end

    it 'require a project' do
      expect(subject).to have(1).error_on :project
      subject.project = build :project
      expect(subject).to have(0).errors_on :project
    end

    it 'require a task' do
      expect(subject).to have(1).error_on :task
      subject.task = build :task
      expect(subject).to have(0).errors_on :task
    end

    it 'require an execution date' do
      expect(subject).to have(1).error_on :executed_on
      subject.executed_on = Date.today
      expect(subject).to have(0).errors_on :executed_on
    end

    it 'require an amount' do
      expect(subject).to have(1).error_on :amount
      subject.amount = -10
      expect(subject).to have(1).error_on :amount
      subject.amount = 1
      expect(subject).to have(0).errors_on :amount
    end

    it 'require the user to be in the same project organization' do
      subject.user = create :user
      subject.project = create :project
      expect(subject).to have(1).error_on :project
    end

    it 'require the task to be one of the project tasks' do
      subject.task = create :task
      subject.project = create :project
      expect(subject).to have(1).error_on :task
    end

    it 'pass when all constraints are met' do
      subject.user = create :user, :organized
      subject.project = create :project, :with_tasks, organization: subject.user.organizations.first
      subject.task = subject.project.tasks.first
      subject.executed_on = Date.today
      subject.amount = 1
      expect(subject).to be_valid
    end

    it 'does not require organization integrity on update' do
      subject = create :time_entry
      subject.project = create :project
      subject.task = create :task
      expect(subject).to be_valid
    end
  end

  describe '#minutes_in_distance' do
    it 'returns the previously set value' do
      subject.instance_variable_set '@minutes_in_distance', 'asd'
      expect(subject.minutes_in_distance).to eq 'asd'
    end

    it 'returns nil if there is no amount' do
      expect(subject.minutes_in_distance).to be_nil
    end

    it 'returns the amount formatted as hours:minutes' do
      subject.amount = 0
      expect(subject.minutes_in_distance).to eq '0:00'
      subject.amount = 95
      expect(subject.minutes_in_distance).to eq '1:35'
    end
  end

  describe '#minutes_in_distance=' do
    it 'stores the value in memory' do
      subject.minutes_in_distance = 'asd'
      expect(subject.instance_variable_get('@minutes_in_distance')).to eq 'asd'
    end

    it 'sets the value as the amount in minutes' do
      subject.minutes_in_distance = '1:35'
      expect(subject.amount).to eq 95
    end

    it 'accepts the value as the number of hours' do
      subject.minutes_in_distance = 1
      expect(subject.amount).to eq 60
    end

    it 'sends to the underlying attribute anything else' do
      expect(subject).to receive(:assign_attributes).with(amount: 'asd')
      subject.minutes_in_distance = 'asd'
    end
  end
end
