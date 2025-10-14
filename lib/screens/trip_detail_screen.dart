import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/trip_provider.dart';
import '../providers/auth_provider.dart';
import '../models/trip.dart';

class TripDetailScreen extends StatefulWidget {
  final int tripId;

  const TripDetailScreen({Key? key, required this.tripId}) : super(key: key);

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  @override
  void initState() {
    super.initState();
    _loadTrip();
  }

  Future<void> _loadTrip() async {
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    await tripProvider.loadTrip(widget.tripId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TripProvider, AuthProvider>(
      builder: (context, tripProvider, authProvider, child) {
        final trip = tripProvider.selectedTrip;
        final currentUser = authProvider.user;
        
        if (tripProvider.isLoading) {
          return Scaffold(
            appBar: AppBar(title: const Text('Loading...')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (trip == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Trip Not Found')),
            body: const Center(
              child: Text('Trip not found or you don\'t have access to it.'),
            ),
          );
        }

        final isCreator = currentUser?.id == trip.createdBy;

        return Scaffold(
          appBar: AppBar(
            title: Text(trip.title),
            actions: [
              if (isCreator)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        _showEditTripDialog(context, trip);
                        break;
                      case 'delete':
                        _showDeleteTripDialog(context, trip);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Edit Trip'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete, color: Colors.red),
                        title: Text('Delete Trip', style: TextStyle(color: Colors.red)),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: _loadTrip,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Trip Header Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  trip.title,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(trip.status),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  trip.status,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          _buildInfoRow(Icons.location_on, 'Destination', trip.destination),
                          const SizedBox(height: 8),
                          
                          _buildInfoRow(
                            Icons.calendar_today,
                            'Duration',
                            '${_formatDate(trip.startDate)} - ${_formatDate(trip.endDate)} (${trip.durationInDays} days)',
                          ),
                          const SizedBox(height: 8),
                          
                          if (trip.budget != null)
                            _buildInfoRow(Icons.attach_money, 'Budget', '\$${trip.budget!.toStringAsFixed(0)}'),
                          if (trip.budget != null) const SizedBox(height: 8),
                          
                          _buildInfoRow(Icons.person, 'Created by', trip.creatorName ?? 'Unknown'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description Card
                  if (trip.description != null && trip.description!.isNotEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(trip.description!),
                          ],
                        ),
                      ),
                    ),
                  if (trip.description != null && trip.description!.isNotEmpty)
                    const SizedBox(height: 16),

                  // Participants Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Participants',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              if (isCreator)
                                IconButton(
                                  icon: const Icon(Icons.person_add),
                                  onPressed: () => _showAddParticipantDialog(context, trip),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          
                          if (trip.participants == null || trip.participants!.isEmpty)
                            const Text(
                              'No participants added yet.',
                              style: TextStyle(color: Colors.grey),
                            )
                          else
                            ...trip.participants!.map((participant) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                child: Text(
                                  '${participant.firstName[0]}${participant.lastName[0]}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              title: Text(participant.fullName),
                              subtitle: Text(participant.email),
                              trailing: isCreator
                                  ? IconButton(
                                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                                      onPressed: () => _removeParticipant(trip, participant.id),
                                    )
                                  : null,
                            )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return Colors.blue;
      case 'ongoing':
        return Colors.green;
      case 'completed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showEditTripDialog(BuildContext context, Trip trip) {
    // Implementation for editing trip
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit trip feature coming soon!')),
    );
  }

  void _showDeleteTripDialog(BuildContext context, Trip trip) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Trip'),
        content: Text('Are you sure you want to delete "${trip.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final tripProvider = Provider.of<TripProvider>(context, listen: false);
              final success = await tripProvider.deleteTrip(trip.id);
              
              if (success && mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Trip deleted successfully')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddParticipantDialog(BuildContext context, Trip trip) {
    final emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Participant'),
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email Address',
            hintText: 'Enter participant\'s email',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = emailController.text.trim();
              if (email.isEmpty) return;
              
              Navigator.of(context).pop();
              
              final tripProvider = Provider.of<TripProvider>(context, listen: false);
              final user = await tripProvider.searchUser(email);
              
              if (user != null) {
                final success = await tripProvider.addParticipant(trip.id, user.id);
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${user.fullName} added to trip')),
                  );
                }
              } else if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User not found')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _removeParticipant(Trip trip, int userId) async {
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    final success = await tripProvider.removeParticipant(trip.id, userId);
    
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Participant removed from trip')),
      );
    }
  }
}
