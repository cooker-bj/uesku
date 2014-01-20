require 'spec_helper'
require 'pry-rescue/rspec'
require 'pry-stack_explorer'
describe CalendarEvent do
  context 'create events' do
    it 'create one event' do
      event=CalendarEvent.add_events({:title=>'test',
                                  :start_time=>1.day.from_now.to_s,
                                   :end_time=>(1.day+1.hour).from_now.to_s,
                                   :user_id=>'1',
                                   :notifications_attributes=>[{:alert_before_event=>'20'}]
                                  })
      CalendarEvent.all.count.should== 1
      CalendarEvent.first.notifications.first.alert_before_event.should==20
    end

    it 'create repeat events on times' do
      CalendarEvent.add_events({:title=>'test',
                                 :start_time=>1.day.from_now.to_s,
                                 :end_time=>(1.day+1.hour).from_now.to_s,
                                 :user_id=>'1',

                                 :notifications_attributes=>[{:alert_before_event=>'20'}]},
                                 {:repeat_every=>1,
                                 :unit=>'week',
                                 :time=>'3'
                               })
      CalendarEvent.all.count.should==3
      CalendarEvent.first.notifications.first.alert_before_event.should==20
    end

    it 'create repeat events on end date' do
      CalendarEvent.add_events({:title=>'test',
                                :start_time=>1.day.from_now.to_s,
                                :end_time=>(1.day+1.hour).from_now.to_s,
                                :user_id=>'1',
                                :notifications_attributes=>[{:alert_before_event=>'20'}]},
                                {
                                :unit=>'week',

                                :repeat_every=>'1',

                                :end_day=>6.week.from_now.strftime("%Y-%m-%d")
                               })
      CalendarEvent.all.count.should==6
      CalendarEvent.first.notifications.first.alert_before_event.should==20
    end
  end

  context 'destroy ' do
    it "destroy one event" do
      events=CalendarEvent.add_events({:title=>'test',
                                            :start_time=>1.day.from_now.to_s,
                                            :end_time=>(1.day+1.hour).from_now.to_s,
                                            :user_id=>'1',
                                            :notifications_attributes=>[{:alert_before_event=>'20'}]
                                           })
       CalendarEvent.first.destroy

      CalendarEvent.all.count.should==0

    end

    it 'destroy the event and events after it' do
     events= CalendarEvent.add_events({:title=>'test',
                                :start_time=>1.day.from_now.to_s,
                                :end_time=>(1.day+1.hour).from_now.to_s,
                                :user_id=>'1',
                                :notifications_attributes=>[{:alert_before_event=>'20'}]},

                                {:unit=>'week',

                                :repeat_every=>1,

                                :end_day=>6.week.from_now.strftime("%Y-%m-%d")
                               })
      event=CalendarEvent.all.slice(3)
      CalendarEvent.remove_events(event.id,'future')
      CalendarEvent.all.count.should==3
    end

  end

  context 'edit' do 
    it 'update one event' do 
       events=CalendarEvent.add_events({:title=>'test',
                                  :start_time=>1.day.from_now.to_s,
                                   :end_time=>(1.day+1.hour).from_now.to_s,
                                   :user_id=>'1',
                                   :notifications_attributes=>[{:alert_before_event=>'20'}]
                                  })
        CalendarEvent.update_events(events.first.id,{
          :title=>'good',:notifications_attributes=>[{:id=>events.first.notifications.first.id,:alert_before_event=>'10'}]
          })
        events.first.reload.title.should=='good'
        events.first.reload.notifications.first.alert_before_event.should==10
    end

    describe 'update attributes in repeated events' do
     
         before(:each)  do 
          @events= CalendarEvent.add_events({:title=>'test',
                                :start_time=>'2014-01-14 07:30',
                                :end_time=>'2014-01-14 08:30',
                                :user_id=>'1',
                                :notifications_attributes=>[{:alert_before_event=>'20'}]},

                                {:unit=>'week',

                                :repeat_every=>1,

                                :end_day=>6.week.from_now.strftime("%Y-%m-%d")
                               }) 
         end
          it 'update all events' do 
            CalendarEvent.update_events(@events.first.id,{:title=>'good',:start_time=>'2014-01-14 07:00',:notifications_attributes=>[{:alert_before_event=>'30'}]},true)
            targe_events=CalendarEvent.where(:event_group_id=>@events.first.event_group_id)
            targe_events.each do |event|
              event.reload.title.should=='good'
            end
            targe_events[1].reload.start_time.should== Time.parse('2014-01-21 07:00')
            targe_events[1].reload.notifications.last.alert_before_event.should==30
          end

          it 'update only one event' do 
            myevents=CalendarEvent.update_events(@events.first.id,{:title=>'bad'},false)
            myevents.first.reload.title.should=='bad'
            @events.last.reload.title.should=='test'
            myevents.first.reload.event_group_id.should be_nil
            myevents.first.reload.notifications.first.alert_before_event.should==20
          end

          it 'delete notifications' do 
            @events.first.notifications.count.should==1
           CalendarEvent.update_events(@events.last.id,{:title=>'good',:notifications_attributes=>[{:id=>@events.first.notifications.first.id,:alert_before_event=>'20',:_destroy=>true}]
          },true)
           @events.first.reload.notifications.count.should==0
         end

    end 
   end
 
end
