class Timer
  def initialize
    @time_elapsed = 0
    @started = false
  end

  def start
    @start_time = Time.now
    @started = true
  end

  def stop
    if @started
      @time_elapsed = Time.now - @start_time
      @started = false
    end

    @time_elapsed
  end

  def elapsed
    @time_elapsed
  end
end
