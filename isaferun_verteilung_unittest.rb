module Localize; end
require "isaferun_verteilung.rb"

puts "Starte Tests"
s = Script.new

@test_count=0
@fail_count=0
def test(cond,line)
  @test_count +=1
  if cond
    puts "Testline #{line} PASS"
	else
    puts "Testline #{line} FAIL"
	@fail_count+=1
	end
end


test(s.opening_time_interval_count([8*60,16*60]) == 16,__LINE__)
test(s.opening_time_interval_count([0,16*60+30]) == 33,__LINE__)
test(s.opening_time_interval_count([16*60,0]) == 16,__LINE__)

test(s.open_at_interval([8*60,16*60],15) == false,__LINE__)
test(s.open_at_interval([8*60,16*60],16) == true,__LINE__)
test(s.open_at_interval([8*60,0],45) == true,__LINE__)

test(s.select_next_partner_to_forecast([0,0,0,0],[1,1,1,1]) == 3, __LINE__)
test(s.select_next_partner_to_forecast([0,0,0,1],[1,1,1,1]) == 2, __LINE__)
test(s.select_next_partner_to_forecast([1,0,0,1],[1,1,1,1]) == 2, __LINE__)
test(s.select_next_partner_to_forecast([0,0,0,1],[1,2,3,4]) == 0, __LINE__)
test(s.select_next_partner_to_forecast([1,0,0,1],[1,2,3,4]) == 1, __LINE__)





puts "#{@test_count} tests total, #{@fail_count} failed"