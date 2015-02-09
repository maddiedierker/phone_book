# This phone book application allows its user to store and retreive their contacts in a relational database using SQLite.
require 'rubygems'
require 'sqlite3'
$phone_book_db = SQLite3::Database.new('phone_book.db')

    def create_table
        puts "Opening your phone book..."
        $phone_book_db.execute %q{
            CREATE TABLE IF NOT EXISTS phone_book (
                id integer primary key,
                name varchar(50),
                phone_number varchar(12),
                street_address varchar(50),
                city_address varchar(50),
                state_address varchar(2),
                zip_address integer(6)
            )
        }
    end

    def add_contact
        print "Enter name: "
        name = gets.chomp
        print "Enter phone number: "
        phone_number = gets.chomp
        print "Enter street address: "
        street_address = gets.chomp
        print "Enter city: "
        city_address = gets.chomp
        print "Enter state: "
        state_address = gets.chomp
        print "Enter zip code: "
        zip_address = gets.chomp
        $phone_book_db.execute("INSERT INTO phone_book (name, phone_number, street_address, city_address, state_address, zip_address) 
            VALUES (?, ?, ?, ?, ?, ?)", name, phone_number, street_address, city_address, state_address, zip_address)
    end

    def find_contact
        puts "Enter name or ID of person to find:"
        id = gets.chomp

        contact = $phone_book_db.execute("SELECT * FROM phone_book WHERE name = ? OR id = ?", id, id.to_i).first

        unless contact
            puts "No results found"
            return
        end

        puts %Q{\tName: #{contact['name']}
        Phone Number: #{contact['phone_number']}
        Street Address: #{contact['street_address']}
        City: #{contact['city_address']}
        State: #{contact['state_address']}
        Zip Code: #{contact['zip_address']}
        }
    end

    def show_all_contacts
        puts $phone_book_db.execute("SELECT * FROM phone_book")
    end

    def disconnect_and_quit
        $phone_book_db.close
        puts "Bye!"
        exit
    end

    loop do
        puts %q{Please select an option:

            1. Create a phone book
            2. Add a contact
            3. Look for a contact
            4. Show all contacts
            5. Quit}

        case gets.chomp
        when '1'
            create_table
        when '2'
            add_contact
        when '3'
            find_contact
        when '4'
            show_all_contacts
        when '5'
            disconnect_and_quit
        end    
    end