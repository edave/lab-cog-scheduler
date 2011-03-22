class SlotsController < ApplicationController
  
  respond_to :html, :json

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
          format.json   {render :layout => false, :status => :unprocessable_entity }
          format.html { access_denied }
      end
    else
    if @experiment.can_modify?(current_user) #redundant
      @slot.cancel()
      @slot.save!
    end
    respond_to do |format|
        format.html { redirect_to(@slot.experiment) }
        format.json   { render :json => ['slot',params[:id]].to_json }
    end
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
        flash.now[:notice] = 'Slot was successfully created.'
        format.html { redirect_to(@slot.experiment) }
        format.json   { render :partial => "slots/show", :locals => {:slot => @slot}, :layout => false, :status => :created }
    end
    else
       respond_with(@slot.errors, :status => :unprocessable_entity) do |format|
          format.json   {render :json => @slot.errors, :layout => false, :status => :unprocessable_entity }
          format.html { render :action => "new" }
        end
    end
  end

  # PUT /slots/1
  # PUT /slots/1.xml
  def update
    @slot = Slot.obfuscated(params[:id]).includes(:experiment)
    if @slot.nil?
      #render_404
      #return
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
    
    # if @experiment.nil? or !@experiment.can_modify?(current_user)
    #   respond_to do |format|
    #       format.json   {render :layout => false, :status => :unprocessable_entity }
    #       format.html { access_denied }
    #   end
    # else
    if @experiment.can_modify?(current_user) #redundant
      @slot.destroy
    end
    respond_to do |format|
            format.html { redirect_to(@slot.experiment) }
            format.json   { render :json => ['slot',params[:id]].to_json, :layout => false }
    end
  end
  
end
