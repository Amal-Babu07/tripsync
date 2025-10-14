const pool = require('../config/database');

class Trip {
  static async create(tripData) {
    const { 
      title, 
      description, 
      destination, 
      startDate, 
      endDate, 
      budget, 
      createdBy 
    } = tripData;
    
    const query = `
      INSERT INTO trips (title, description, destination, start_date, end_date, budget, created_by)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      RETURNING *
    `;
    
    const values = [title, description, destination, startDate, endDate, budget, createdBy];
    const result = await pool.query(query, values);
    return result.rows[0];
  }

  static async findById(id) {
    const query = `
      SELECT t.*, u.first_name, u.last_name, u.email as creator_email
      FROM trips t
      JOIN users u ON t.created_by = u.id
      WHERE t.id = $1
    `;
    const result = await pool.query(query, [id]);
    return result.rows[0];
  }

  static async findByUserId(userId) {
    const query = `
      SELECT t.*, u.first_name, u.last_name
      FROM trips t
      JOIN users u ON t.created_by = u.id
      WHERE t.created_by = $1 OR t.id IN (
        SELECT trip_id FROM trip_participants WHERE user_id = $1
      )
      ORDER BY t.created_at DESC
    `;
    const result = await pool.query(query, [userId]);
    return result.rows;
  }

  static async updateById(id, updateData) {
    const fields = [];
    const values = [];
    let paramCount = 1;

    Object.keys(updateData).forEach(key => {
      if (updateData[key] !== undefined) {
        fields.push(`${key} = $${paramCount}`);
        values.push(updateData[key]);
        paramCount++;
      }
    });

    if (fields.length === 0) {
      throw new Error('No fields to update');
    }

    values.push(id);
    const query = `
      UPDATE trips 
      SET ${fields.join(', ')}, updated_at = CURRENT_TIMESTAMP
      WHERE id = $${paramCount}
      RETURNING *
    `;

    const result = await pool.query(query, values);
    return result.rows[0];
  }

  static async deleteById(id) {
    const query = 'DELETE FROM trips WHERE id = $1 RETURNING id';
    const result = await pool.query(query, [id]);
    return result.rows[0];
  }

  static async addParticipant(tripId, userId) {
    const query = `
      INSERT INTO trip_participants (trip_id, user_id)
      VALUES ($1, $2)
      ON CONFLICT (trip_id, user_id) DO NOTHING
      RETURNING *
    `;
    const result = await pool.query(query, [tripId, userId]);
    return result.rows[0];
  }

  static async removeParticipant(tripId, userId) {
    const query = 'DELETE FROM trip_participants WHERE trip_id = $1 AND user_id = $2';
    const result = await pool.query(query, [tripId, userId]);
    return result.rowCount > 0;
  }

  static async getParticipants(tripId) {
    const query = `
      SELECT u.id, u.email, u.first_name, u.last_name, tp.joined_at
      FROM trip_participants tp
      JOIN users u ON tp.user_id = u.id
      WHERE tp.trip_id = $1
      ORDER BY tp.joined_at ASC
    `;
    const result = await pool.query(query, [tripId]);
    return result.rows;
  }
}

module.exports = Trip;
