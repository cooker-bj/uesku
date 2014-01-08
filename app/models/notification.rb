class Notification < ActiveRecord::Base
  attr_accessible :alert_before_event, :calendar_event_id
  belongs_to :calendar_event,:dependent=>:destroy
end
