def the_weight (set1, set2)
    set1.each {|item| fill_in "left_#{item}", with: item}
    set2.each {|item| fill_in "right_#{item}", with: item}
    click_button 'weigh'
    out = [-1]
    if (find('div.result #reset').text === '=') 
        out = [8]
    end
    if (find('div.result #reset').text === '<') 
        out = set1
    end
    if (find('div.result #reset').text === '>') 
        out = set2
    end
    find('div:not(.result) > #reset').click()
    return out
end

def compare_against_zero(right_value)
    fill_in "left_0", with: 0
    fill_in "right_1", with: right_value
    click_button 'weigh'
end

describe "the fake brick detector page", type: :feature do
    before :each do
        visit 'http://ec2-54-208-152-154.compute-1.amazonaws.com/'
    end
    it "finds the fake brick with the fewest guesses (1 or 3)" do # 2.81s 3 guesses 2.2s 1 guess     
        suspects = [0,1,2,3,4,5,6,7]
        while (suspects.length > 1) do
            suspects = the_weight(suspects.take(suspects.length/2),suspects.drop((suspects.length/2)))
        end
        click_button "coin_#{suspects[0]}"
        expect(page.accept_alert).to have_content('Yay! You find it!')
    end
    it "finds the fake brick as fast as possible" do # only slightly, and on average  5 guesses took  2.53s  obviously the first test scales much better as the bricks increase past the mere 9.
        right_value = 1
        compare_against_zero(right_value)
        while (find('div.result #reset').text === '=') do
            find('div:not(.result) > #reset').click()
            right_value+=1
            compare_against_zero(right_value)
        end
        if (find('div.result #reset').text === '<') 
            click_button "coin_0"
            expect(page.accept_alert).to have_content('Yay! You find it!')
        end
        if (find('div.result #reset').text === '>') 
            click_button "coin_#{right_value}"
            expect(page.accept_alert).to have_content('Yay! You find it!')
        end
    end
    it "has a functional weigh button when used correctly" do
        fill_in "left_0", with: 0
        fill_in "right_1", with: 1
        click_button 'weigh'
        unless ['=', '<', '>'].include?(find('div.result #reset').text)
            puts "#{find('div.result #reset').text} is not an expected value, only =, >, or <"
            expect(object).to receive(:save).and_raise(ActiveRecord::StaleObjectError)
        end
    end
    it "rejects gracefully when you try to weigh the same number" do
        fill_in "left_0", with: 0
        fill_in "right_1", with: 0
        click_button 'weigh'
        expect(page.accept_alert).to have_content('Inputs are invalid: Both sides have coin(s): 0')
    end
    it "rejects gracefully when you have duplicates on ones side" do
        fill_in "left_0", with: 0
        fill_in "left_1", with: 0
        click_button 'weigh'
        expect(page.accept_alert).to have_content('Inputs are invalid: Left side has duplicates')
        find('div:not(.result) > #reset').click()
        fill_in "right_0", with: 0
        fill_in "right_1", with: 0
        click_button 'weigh'
        expect(page.accept_alert).to have_content('Inputs are invalid: Right side has duplicates') 
    end
    it "has a proper 9 square 'basket' to hold all the gold bricks" do
        9.times do |num|
          fill_in "left_#{num}", with: num
          fill_in "right_#{num}", with: num
          expect("left_#{num}").to have_content(num), lambda { "expected to find #{num} in left_#{num}, found #{num} instead" } 
          expect("right_#{num}").to have_content(num)
        end
    end
    it "has a reset button to clear the basket" do
        fill_in "right_0", with: 1
        fill_in "right_1", with: 5
        find('div:not(.result) > #reset').click()
        expect('left_0').to have_no_content(1)
        expect('right_1').to have_no_content(5)
    end
    it "rejects with an 'oops' error when most gold brick tiles are pressed" do
        8.times do |num|
            click_button "coin_#{num}"
            alert_message = page.accept_alert
            unless ['Yay! You find it!', 'Oops! Try Again!'].include?(alert_message)
                puts "#{alert_message} is not an expected value, only 'Yay! You find it!', or 'Oops! Try Again!'"
                expect(object).to receive(:save).and_raise(ActiveRecord::StaleObjectError)
            end 
        end
    end
    it "provides a record of weightings made to discover fake brick" do
        the_weight([0,1,2,3],[4,5,6,7])
        #sleep(300)
        expect(page).to have_selector('div.game-info li')
        expect(page).to have_xpath(".//li[contains(text(),'[0,1,2,3]')]")
        expect(page).to have_xpath(".//li[contains(text(),'[4,5,6,7]')]")
    end
end