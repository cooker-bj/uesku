module AuditContent

  #class methods
  module AuditCollection
    def audit_all
     where(:audit=>true)
    end

    def un_audit_all
      where(:audit=>false)
   end
  end

   #instance methods
  def set_audit
    self.audit=true
    self.save
  end

  def withdraw_audit
    self.audit=false
    self.save
  end

  def self.included(base)
    base.extend AuditCollection
  end


end