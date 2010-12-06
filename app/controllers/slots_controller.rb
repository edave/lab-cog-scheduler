class SlotsController < ApplicationController
  
   respond_to :html, :json, :js
  # GET /slots
  # GET /slots.xml
  def index
    @experiment = Experiment.obfuscated(params[:experiment])
    page_group(@experiment.user.group)
    
    if @experiment.nil? or !@experiment.can_modify?(current_user)
      access_denied
      return
    end
    @slots = Slot.where(:experiment_id => @experiment.id).order("time")
    page_title([@experiment.name, "Time Slots"])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @slots }
    end
  end

  # GET /slots/1
  # GET /slots/1.xml
  def show    
    @slot = Slot.obfuscated_query(params[:id]).includes(:experiment).first
    if @slot == nil
      render_404
      return
    end
    @experiment = @slot.experiment
    page_group(@experiment.user.group)
    
    if @experiment.nil? or !@experiment.can_modify?(current_user)
      access_denied
      return
    end
    if @experiment.can_modify?(current_user)
    page_title([@experiment.name, "Slot", @slot.human_time])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @slot }
    end
    else
      
    end
  end

  # GET /slots/new
  # GET /slots/new.xml
  def new
    page_title("New Time Slot")
    @slot = Slot.new
    @experiment = Experiment.obfuscated_query(params[:id]).includes(:slots).first
    page_group(@experiment.user.group)
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @slot }
    end
  end

  def cancel
    @slot = Slot.obfuscated_query(params[:id]).includes(:experiment).first
    if @slot.nil?
      render_404
      return
    end
    @experiment = @slot.experiment
    page_group(@experiment.user.group)
    
    if @experiment.nil? or !@experiment.can_modify?(current_user)
      respond_to do |format|
          format.js   {render :layout => false, :status => :unprocessable_entity }
          format.html { access_denied }
      end
    else
    if @experiment.can_modify?(current_user) #redundant
     # @slot.cancel()
      @slot.save!
    end
     respond_to do |format|
        format.html { redirect_to(@slot.experiment) }
        format.js   { render :json => ['slot',params[:id]].to_json, :layout => false }
    end
  end
  end

  # GET /slots/1/edit
  def edit
    @slot = Slot.obfuscated(params[:id]).includes(:experiment)
    if @slot.nil?
      render_404
      return
    end
    @experiment = @slot.experiment
    page_group(@experiment.user.group)
    
    if @experiment.nil? or !@experiment.can_modify?(current_user)
      access_denied
      return
    end
    if @experiment.owned_by?(current_user)
    page_title([@experiment.name, "Edit Slot", @slot.human_time])
    else
    redirect_to(:controller => :slots, :action => :index, :experiment=> @experiment.hashed_id)
    end
  end

  # POST /slots
  # POST /slots.xml
  def create
    @slot = Slot.new()
    experiment = Experiment.obfuscated(params[:experiment_id])
    page_group(experiment.user.group)
    
    if experiment.nil? or !experiment.can_modify?(current_user)
      access_denied
      return
    end
    @slot.experiment = experiment
    
    @slot.parse_datetime([params[:slot][:date], params[:slot][:time_hour] + ":" + params[:slot][:time_min],
                              params[:slot][:time_12h], experiment.time_zone].join(" "))
    
    if @slot.save
    respond_with(@slot, :status => :created, :location => @slot) do |format|
        flash[:notice] = 'Slot was successfully created.'
        format.html { redirect_to(@slot.experiment) }
        format.js   { render :partial => "slots/show", :locals => {:slot => @slot}, :layout => false, :status => :created }
    end
    else
       respond_with(@slot.errors, :status => :unprocessable_entity) do |format|
          format.js   {render :json => @slot.errors, :layout => false, :status => :unprocessable_entity }
          format.html { render :action => "new" }
        end
    end
  end

  # PUT /slots/1
  # PUT /slots/1.xml
  def update
    @slot = Slot.obfuscated(params[:id]).includes(:experiment)
    if @slot.nil?
      render_404
      return
    end
    @experiment = @slot.experiment
    page_group(@experiment.user.group)
    
    if @experiment.nil? or !@experiment.can_modify?(current_user)
      access_denied
      return
    end
    respond_to do |format|
      if @experiment.can_modify?(current_user) and @slot.update_attributes(params[:slot])
        flash[:notice] = 'Slot was successfully updated.'
        format.html { redirect_to(@slot) }
        format.xml  { head :ok }
      else
        
        format.html { render :action => "edit" }
        format.xml  { render :xml => @slot.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /slots/1
  # DELETE /slots/1.xml
  def destroy
    @slot = Slot.obfuscated_query(params[:id]).includes(:experiment).first
    if @slot.nil?
      render_404
      return
    end
    @experiment = @slot.experiment
    page_group(@experiment.user.group)
    
    if @experiment.nil? or !@experiment.can_modify?(current_user)
      respond_to do |format|
          format.js   {render :layout => false, :status => :unprocessable_entity }
          format.html { access_denied }
      end
    else
    if @experiment.can_modify?(current_user) #redundant
      @slot.destroy
    end
     respond_to do |format|
        format.html { redirect_to(@slot.experiment) }
        format.js   { render :json => ['slot',params[:id]].to_json, :layout => false }
    end
  end
  end
  
end
