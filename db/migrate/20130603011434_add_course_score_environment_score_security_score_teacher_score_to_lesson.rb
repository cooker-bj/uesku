class AddCourseScoreEnvironmentScoreSecurityScoreTeacherScoreToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :course_score, :decimal,:null=>false,:default=>0.0,:precision=>2,:scale=>1
    add_column :lessons, :environment_score, :decimal,:null=>false,:default=>0.0,:precision=>2,:scale=>1
    add_column :lessons, :security_score, :decimal  ,:null=>false,:default=>0.0,:precision=>2,:scale=>1
    add_column :lessons, :teacher_score, :decimal ,:null=>false,:default=>0.0,:precision=>2,:scale=>1
  end
end
