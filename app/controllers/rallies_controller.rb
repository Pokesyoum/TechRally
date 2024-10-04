class RalliesController < ApplicationController
  def index
    @rallies = Rally.all
  end
end
