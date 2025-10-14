import 'package:flutter/material.dart';

// ---------------- Reports & Analytics Screen ----------------
class ReportsAnalyticsScreen extends StatefulWidget {
  const ReportsAnalyticsScreen({super.key});

  @override
  State<ReportsAnalyticsScreen> createState() => _ReportsAnalyticsScreenState();
}

class _ReportsAnalyticsScreenState extends State<ReportsAnalyticsScreen> {
  String _selectedPeriod = 'This Week';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        backgroundColor: Colors.blue.shade900,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading report...')),
              );
            },
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'export_pdf', child: Text('Export as PDF')),
              const PopupMenuItem(value: 'export_excel', child: Text('Export as Excel')),
              const PopupMenuItem(value: 'share', child: Text('Share Report')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.blue),
                    const SizedBox(width: 12),
                    const Text(
                      'Period:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButton<String>(
                        value: _selectedPeriod,
                        isExpanded: true,
                        items: ['Today', 'This Week', 'This Month', 'This Year']
                            .map((period) => DropdownMenuItem(
                                  value: period,
                                  child: Text(period),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPeriod = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Overview Stats
            const Text(
              'Overview Statistics',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(child: _buildStatCard('Total Trips', '245', Icons.route, Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Students', '150', Icons.people, Colors.green)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildStatCard('Avg Distance', '32 km', Icons.straighten, Colors.orange)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('On-Time %', '94%', Icons.check_circle, Colors.purple)),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Bus Performance
            const Text(
              'Bus Performance',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            _buildBusPerformanceCard('Bus 1 - Chalakudy', 52, 48, 95, Colors.blue),
            _buildBusPerformanceCard('Bus 2 - Paravattani', 48, 45, 92, Colors.green),
            _buildBusPerformanceCard('Bus 3 - Vadakke Stand', 45, 42, 89, Colors.orange),
            _buildBusPerformanceCard('Bus 4 - Thriprayar', 50, 47, 96, Colors.purple),
            _buildBusPerformanceCard('Bus 5 - Kunnamkulam', 50, 46, 91, Colors.red),
            
            const SizedBox(height: 24),
            
            // Attendance Report
            const Text(
              'Attendance Report',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildAttendanceRow('Monday', 145, 150),
                    _buildAttendanceRow('Tuesday', 148, 150),
                    _buildAttendanceRow('Wednesday', 142, 150),
                    _buildAttendanceRow('Thursday', 147, 150),
                    _buildAttendanceRow('Friday', 149, 150),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Route Efficiency
            const Text(
              'Route Efficiency',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildEfficiencyRow('Chalakudy Route', 28, 30, 93),
                    _buildEfficiencyRow('Paravattani Route', 35, 38, 92),
                    _buildEfficiencyRow('Vadakke Stand Route', 42, 45, 93),
                    _buildEfficiencyRow('Thriprayar Route', 25, 27, 93),
                    _buildEfficiencyRow('Kunnamkulam Route', 48, 52, 92),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusPerformanceCard(String busName, int trips, int students, int onTime, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.directions_bus, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    busName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetric('Trips', '$trips', Icons.route),
                _buildMetric('Students', '$students', Icons.people),
                _buildMetric('On-Time', '$onTime%', Icons.access_time),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildAttendanceRow(String day, int present, int total) {
    double percentage = (present / total) * 100;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$present / $total'),
                    Text('${percentage.toStringAsFixed(1)}%'),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    percentage >= 95 ? Colors.green : percentage >= 85 ? Colors.orange : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEfficiencyRow(String route, int avgTime, int scheduledTime, int efficiency) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(route, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Text('$avgTime min', textAlign: TextAlign.center),
          ),
          Expanded(
            child: Text('$scheduledTime min', textAlign: TextAlign.center),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: efficiency >= 90 ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$efficiency%',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: efficiency >= 90 ? Colors.green : Colors.orange,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
