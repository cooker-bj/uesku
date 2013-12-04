require 'spec_helper'

describe User do
  context "format_date" do
    it 'should make invalided date to valid' do
      mydate="1970-0-0"
      formated_date=User.date_format(mydate)
      formated_date.should == '1970-01-01'
    end

    it "should keep valid date unchanged"  do
      mydate="1970-02-16"
      format_date=User.date_format(mydate)
      format_date.should==mydate
    end

    it "should return a date if get null" do
      date=User.date_format(nil)
      date.should=='1970-01-01'
    end
  end

  context "unify the gender" do
    it "should keep '男' as '男'"  do
      gender='男'
      my_gender=User.get_gender(gender)
      my_gender.should==gender
    end

    it "should translate male to '男'" do
      gender='male'
      my_gender=User.get_gender(gender)
      my_gender.should=='男'
    end

    it "should keep '女' as '女'"  do
      gender='女'
      my_gender=User.get_gender(gender)
      my_gender.should==gender
    end

    it "should translate female to '女'" do
      gender='female'
      my_gender=User.get_gender(gender)
      my_gender.should=='女'
    end

    it "should translate others to '男'" do
      gender='other'
      my_gender=User.get_gender(gender)
      my_gender.should=='男'
    end
  end

  context "nickname cannot be empty"  do
    it "should keep value if it have a nickname"  do
      nick="my boy"
      myuser=User.create(:nickname=>nick)
      p myuser.errors if myuser.id.nil?

      myuser.reload.nickname.should==nick
    end

    it "should have a nickname if nickname is empty" do
      myuser=User.create()

      myuser.reload.nickname.should_not be_nil

    end
  end
end