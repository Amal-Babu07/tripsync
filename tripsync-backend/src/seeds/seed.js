const pool = require('../config/database');
const bcrypt = require('bcryptjs');

async function seedDatabase() {
  try {
    console.log('🌱 Starting database seeding...');

    // Check if data already exists
    const userCount = await pool.query('SELECT COUNT(*) FROM users');
    if (parseInt(userCount.rows[0].count) > 0) {
      console.log('📊 Database already contains data, skipping seed');
      return;
    }

    // Create sample users
    const hashedPassword = await bcrypt.hash('password123', 12);
    
    const users = [
      {
        email: 'john.doe@example.com',
        password_hash: hashedPassword,
        first_name: 'John',
        last_name: 'Doe',
        phone_number: '+1-555-0101'
      },
      {
        email: 'jane.smith@example.com',
        password_hash: hashedPassword,
        first_name: 'Jane',
        last_name: 'Smith',
        phone_number: '+1-555-0102'
      },
      {
        email: 'mike.johnson@example.com',
        password_hash: hashedPassword,
        first_name: 'Mike',
        last_name: 'Johnson',
        phone_number: '+1-555-0103'
      }
    ];

    console.log('👥 Creating sample users...');
    const createdUsers = [];
    for (const user of users) {
      const result = await pool.query(`
        INSERT INTO users (email, password_hash, first_name, last_name, phone_number)
        VALUES ($1, $2, $3, $4, $5)
        RETURNING id, email, first_name, last_name
      `, [user.email, user.password_hash, user.first_name, user.last_name, user.phone_number]);
      
      createdUsers.push(result.rows[0]);
      console.log(`✅ Created user: ${result.rows[0].first_name} ${result.rows[0].last_name} (${result.rows[0].email})`);
    }

    // Create sample trips
    const trips = [
      {
        title: 'Summer Vacation in Bali',
        description: 'A relaxing trip to explore the beautiful beaches and culture of Bali',
        destination: 'Bali, Indonesia',
        start_date: '2024-07-15',
        end_date: '2024-07-25',
        budget: 2500.00,
        created_by: createdUsers[0].id
      },
      {
        title: 'European Adventure',
        description: 'Backpacking through major European cities',
        destination: 'Europe',
        start_date: '2024-09-01',
        end_date: '2024-09-20',
        budget: 3500.00,
        created_by: createdUsers[1].id
      },
      {
        title: 'Weekend Getaway to Mountains',
        description: 'A short hiking trip to the nearby mountains',
        destination: 'Rocky Mountains, Colorado',
        start_date: '2024-06-08',
        end_date: '2024-06-10',
        budget: 800.00,
        created_by: createdUsers[2].id
      }
    ];

    console.log('🗺️  Creating sample trips...');
    const createdTrips = [];
    for (const trip of trips) {
      const result = await pool.query(`
        INSERT INTO trips (title, description, destination, start_date, end_date, budget, created_by)
        VALUES ($1, $2, $3, $4, $5, $6, $7)
        RETURNING id, title, destination
      `, [trip.title, trip.description, trip.destination, trip.start_date, trip.end_date, trip.budget, trip.created_by]);
      
      createdTrips.push(result.rows[0]);
      console.log(`✅ Created trip: ${result.rows[0].title} to ${result.rows[0].destination}`);
    }

    // Add some trip participants
    console.log('👫 Adding trip participants...');
    
    // Add Jane to John's Bali trip
    await pool.query(`
      INSERT INTO trip_participants (trip_id, user_id)
      VALUES ($1, $2)
    `, [createdTrips[0].id, createdUsers[1].id]);
    console.log(`✅ Added ${createdUsers[1].first_name} to ${createdTrips[0].title}`);

    // Add Mike to Jane's European trip
    await pool.query(`
      INSERT INTO trip_participants (trip_id, user_id)
      VALUES ($1, $2)
    `, [createdTrips[1].id, createdUsers[2].id]);
    console.log(`✅ Added ${createdUsers[2].first_name} to ${createdTrips[1].title}`);

    console.log('🎉 Database seeding completed successfully!');
    console.log('');
    console.log('📋 Sample Data Created:');
    console.log('Users:');
    createdUsers.forEach(user => {
      console.log(`  - ${user.first_name} ${user.last_name} (${user.email}) - Password: password123`);
    });
    console.log('');
    console.log('Trips:');
    createdTrips.forEach(trip => {
      console.log(`  - ${trip.title} to ${trip.destination}`);
    });

  } catch (error) {
    console.error('❌ Seeding failed:', error);
    process.exit(1);
  } finally {
    await pool.end();
  }
}

// Run seeding if this file is executed directly
if (require.main === module) {
  seedDatabase();
}

module.exports = seedDatabase;
