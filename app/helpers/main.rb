class Main
  helpers do
    def logged_in?
      return false unless request.cookies.has_key?("staff_challenge") && request.cookies.has_key?("staff")
      
      @user = Jumper.get(request.cookies['staff'])
      return false if @user.nil?
      
      @user = nil unless @user.challenges && @user.challenges.include?(request.cookies['staff_challenge'])
      return false if @user.nil?
      
      return true
    end
  end
end
