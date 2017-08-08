require 'httparty'

def pof(text)
  if text == "PASSED"
    "[ \e[32mPASSED!\e[0m ] "
  else
    "[ \e[31mFAILED!\e[0m ] "
  end
end

class RESTtester
  def self.test_2
    print "Testing reading of all contacts..."
    req = HTTParty.get('http://localhost:4567/contacts')
    begin
      all_result = req.length > 0 ? "PASSED" : "FAILED"
    rescue
      all_result = "FAILED"
    end
    puts pof(all_result)

    print "Testing reading of single contact..."
    req = HTTParty.get('http://localhost:4567/contacts/1')
    begin
      show_result = req.length > 0 ? "PASSED" : "FAILED"
    rescue
      show_result = "FAILED"
    end
    puts pof(show_result)

    print "Testing creation of single contact..."
    req = HTTParty.post('http://localhost:4567/contacts', query: {
      first_name: 'Testy',
      last_name: 'McTesterson',
      phone: '1-800-hustle',
      email: 'testy@mctestersons.co',
      company: 1,
      title: 'Bruh'
    })
    begin
      create_result = req.length > 0 ? "PASSED" : "FAILED"
    rescue
      create_result = "FAILED"
    end
    created_id = create_result == "PASSED" ? req.parsed_response.first['id'] : 1
    puts pof(create_result)

    print "Testing update of single contact..."
    req = HTTParty.put("http://localhost:4567/contacts/#{created_id}", query: {
      field: "phone",
      value: "1-900-getmoney"
    })
    begin
      update_result = req.length > 0 && req.parsed_response.first['phone'].start_with?('1-900-getmoney') ? "PASSED" : "FAILED"
    rescue
      update_result = "FAILED"
    end
    puts pof(update_result)

    print "Testing delete of single contact..."
    req = HTTParty.delete("http://localhost:4567/contacts/#{created_id}")
    begin
      delete_result = req.code == 204 ? "PASSED" : "FAILED"
    rescue
      delete_result = "FAILED"
    end
    puts pof(delete_result)
  end
end

RESTtester.test_2
