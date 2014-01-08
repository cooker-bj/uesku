require 'spec_helper'
require 'pry-rescue/rspec'
require 'pry-stack_explorer'
describe CalendarEvent do
  context 'create events' do
    it 'create one event' do
      event=CalendarEvent.add_events({:title=>'test',
                                  :start_time=>1.day.from_now,
                                   :end_time=>(1.day+1.hour).from_now,
                                   :user_id=>1,
                                   :notifications_attributes=>[{:alert_before_event=>20}]
                                  })
      CalendarEvent.all.count.should== 1
    end

    it 'create repeat events on times' do
      CalendarEvent.add_events({:title=>'test',
                                 :start_time=>1.day.from_now.to_s,
                                 :end_time=>(1.day+1.hour).from_now.to_s,
                                 :user_id=>1,
                                 :repeat=>true,
                                 :unit=>'周',
                                 :notifications_attributes=>[{:alert_before_event=>20}],
                                 :repeat_every=>1,

                                 :end_period=>{:time=>3}
                               })
      CalendarEvent.all.count.should==3
    end

    it 'create repeat events on end date' do
      CalendarEvent.add_events({:title=>'test',
                                :start_time=>1.day.from_now.to_s,
                                :end_time=>(1.day+1.hour).from_now.to_s,
                                :user_id=>1,
                                :repeat=>true,
                                :unit=>'周',
                                :notifications_attributes=>[{:alert_before_event=>20}],
                                :repeat_every=>1,

                                :end_period=>{:end_day=>6.week.from_now.strftime("%Y-%m-%d")}
                               })
      CalendarEvent.all.count.should==6
    end
  end

  context 'destroy ' do
    it "destroy one event" do
      events=CalendarEvent.add_events({:title=>'test',
                                            :start_time=>1.day.from_now.to_s,
                                            :end_time=>(1.day+1.hour).from_now.to_s,
                                            :user_id=>1,
                                            :notifications_attributes=>[{:alert_before_event=>20}]
                                           })
      events.first.destroy

      CalendarEvent.all.count.should==0

    end

    it 'destroy the event and events after it' do
     events= CalendarEvent.add_events({:title=>'test',
                                :start_time=>1.day.from_now.to_s,
                                :end_time=>(1.day+1.hour).from_now.to_s,
                                :user_id=>1,
                                :repeat=>true,
                                :unit=>'周',
                                :notifications_attributes=>[{:alert_before_event=>20}],
                                :repeat_every=>1,

                                :end_period=>{:end_day=>6.week.from_now.strftime("%Y-%m-%d")}
                               })
      events[3].destroy(true)
      CalendarEvent.all.count.should==3
    end

  end
end
