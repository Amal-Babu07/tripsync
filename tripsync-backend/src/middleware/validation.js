const Joi = require('joi');

const validateRequest = (schema) => {
  return (req, res, next) => {
    const { error } = schema.validate(req.body);
    
    if (error) {
      return res.status(400).json({
        error: 'Validation error',
        message: error.details[0].message,
        details: error.details
      });
    }
    
    next();
  };
};

// User validation schemas
const userRegistrationSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().min(6).required(),
  firstName: Joi.string().min(2).max(50).required(),
  lastName: Joi.string().min(2).max(50).required(),
  phoneNumber: Joi.string().pattern(/^\+?[\d\s-()]+$/).optional(),
  role: Joi.string().valid('student', 'driver').optional(),
  studentId: Joi.string().max(50).optional(),
  licenseNumber: Joi.string().max(50).optional(),
  vehicleNumber: Joi.string().max(50).optional()
});

const userLoginSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().required()
});

const userUpdateSchema = Joi.object({
  firstName: Joi.string().min(2).max(50).optional(),
  lastName: Joi.string().min(2).max(50).optional(),
  phoneNumber: Joi.string().pattern(/^\+?[\d\s-()]+$/).optional()
});

// Trip validation schemas
const tripCreationSchema = Joi.object({
  title: Joi.string().min(3).max(100).required(),
  description: Joi.string().max(500).optional(),
  destination: Joi.string().min(2).max(100).required(),
  startDate: Joi.date().iso().required(),
  endDate: Joi.date().iso().greater(Joi.ref('startDate')).required(),
  budget: Joi.number().positive().optional()
});

const tripUpdateSchema = Joi.object({
  title: Joi.string().min(3).max(100).optional(),
  description: Joi.string().max(500).optional(),
  destination: Joi.string().min(2).max(100).optional(),
  startDate: Joi.date().iso().optional(),
  endDate: Joi.date().iso().optional(),
  budget: Joi.number().positive().optional()
}).custom((value, helpers) => {
  if (value.startDate && value.endDate && value.startDate >= value.endDate) {
    return helpers.error('any.invalid', { message: 'End date must be after start date' });
  }
  return value;
});

module.exports = {
  validateRequest,
  userRegistrationSchema,
  userLoginSchema,
  userUpdateSchema,
  tripCreationSchema,
  tripUpdateSchema
};
