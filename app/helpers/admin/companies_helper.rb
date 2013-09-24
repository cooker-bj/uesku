module Admin::CompaniesHelper
  def add_new_branch(name)
      link_to_function name,nil  do |page|
        page.insert_html :bottom, :branches, :partial => 'branch', :object => Branch.new
      end

  end
end