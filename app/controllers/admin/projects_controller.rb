class Admin::ProjectsController < Admin::BaseController
  before_filter do
    breadcrumbs.add "Events", admin_events_path
    breadcrumbs.add event.title, edit_admin_event_path(event)
    breadcrumbs.add "Projects", admin_event_projects_path(event)
  end

  def update
    if project.update_attributes(project_params)
      redirect_to admin_event_projects_path(event)
    else
      render action: :edit
    end
  end

  def destroy
    project.destroy
    redirect_to admin_event_projects_path
  end

  def projects
    @projects ||= event.projects
  end
  helper_method :projects

  def project
    @project ||= projects.find_by_slug(params[:id])
  end
  helper_method :project

  def event
    @event ||= Event.find_by_slug(params[:event_id])
  end
  helper_method :event

private
  def project_params
    params.fetch(:project, {}).permit(:title, :team, :url, :secret, :image,
      :summary, :description, :ideas, :data, :twitter, :github_url, :svn_url,
      :code_url, :awards_attributes, :centre, :centre_id, :slug)
  end

end
