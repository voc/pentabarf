class AdminController < ApplicationController

  before_filter :init

  def index
    @content_title = 'Admin'
  end

  def conflict_setup
    @content_title = 'Conflict Setup'
    @phases = Conference_phase_localized.select(:translated=>@current_language)
    @conflicts = Conflict_localized.select({:translated=>@current_language})
    @level = Conflict_level_localized.select(:translated=>@current_language).map{|l|[l.conflict_level,l.name]}
    @phase_conflicts = Conference_phase_conflict.select
  end

  def save_conflict_setup
    params[:conflict].each do | conflict, outer |
      outer.each do | conference_phase, value |
        write_row( Conference_phase_conflict, value, {:preset=>{:conflict=>conflict,:conference_phase=>conference_phase}})
      end
    end
    redirect_to( :action => :conflict_setup )
  end

  def custom_fields
    @content_title = 'Custom fields'
    @custom_fields = Custom_fields.select({},{:order=>[:table_name,:field_name]})
  end

  def save_custom_fields
    write_rows( Custom_fields, params[:custom_fields], {:ignore_empty=>:field_name,:always=>[:not_null]})
    redirect_to( :action => :custom_fields )
  end

  protected

  def init
    @current_conference = Conference.select_single(:conference_id => POPE.user.current_conference_id)
    @current_language = POPE.user.current_language
  end

end
