class ConditionalPagesScenario < Scenario::Base
  uses :home_page, :users

  def load
    create_page "Parent Page" do
      create_page_part "parent-body",
                       :name => 'body',
                       :content => "Parent Page Body Text"
      create_page_part "parent-other",
                       :name => 'other',
                       :content => "Parent Page Other Text"
      create_page_part "parent-another",
                       :name => 'another',
                       :content => "Parent Page Another Text"

      create_page "Child Page" do
        create_page_part "child-body",
                         :name => 'body',
                         :content => "Child Page Body Text"
        create_page_part "child-other",
                         :name => 'other',
                         :content => "Child Page Other Text"
      end

      create_page "Another Child Page"
    end

    UserActionObserver.current_user = users(:admin)
    Page.update_all "created_by_id = #{user_id(:admin)}, updated_by_id = #{user_id(:non_admin)}"
  end
end