import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/vehicle/vehicle_event.dart';
import '../bloc/vehicle/vehicle_bloc.dart';
import '../bloc/vehicle/vehicle_state.dart';
import 'vehicle_detail_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String searchQuery = '';
  String selectedPriceRange = 'All';

  final List<String> priceRanges = [
    'All',
    'Below 10,000',
    '10,000 - 20,000',
    'Above 20,000',
  ];

  @override
  void initState() {
    super.initState();
    context.read<VehicleBloc>().add(FetchVehicles());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
  preferredSize: const Size.fromHeight(100),
  child: AppBar(
    elevation: 6,
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 10, 104, 218), Color.fromARGB(255, 85, 86, 86)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(30),
      ),
    ),
    centerTitle: true,
    title: Column(
      children: [
        const SizedBox(height: 20),
        Text(
          'Zop Media',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        
        ),
      ],
    ),
    leading: Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Icon(
        Icons.directions_car_filled_rounded,
        color: Colors.white,
        size: 30,
      ),
    ),
  ),
),

      body: BlocBuilder<VehicleBloc, VehicleState>(
        builder: (context, state) {
          if (state.status == VehicleStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == VehicleStatus.failure) {
            return Center(
              child: Text(state.errorMessage ?? 'Something went wrong'),
            );
          }

          final filteredVehicles =
              state.vehicles.where((vehicle) {
                final matchesSearch = '${vehicle.make} ${vehicle.model}'
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase());

                final matchesPrice = () {
                  switch (selectedPriceRange) {
                    case 'Below 10,000':
                      return vehicle.price < 10000;
                    case '10,000 - 20,000':
                      return vehicle.price >= 10000 && vehicle.price <= 20000;
                    case 'Above 20,000':
                      return vehicle.price > 20000;
                    default:
                      return true;
                  }
                }();

                return matchesSearch && matchesPrice;
              }).toList();

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search by name',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 10,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: selectedPriceRange,
                      dropdownColor: Colors.white,
                      items:
                          priceRanges.map((range) {
                            return DropdownMenuItem<String>(
                              value: range,
                              child: Text(range),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPriceRange = value!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<VehicleBloc>().add(FetchVehicles());
                    },
                    child: GridView.builder(
                      itemCount: filteredVehicles.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 3 / 4,
                          ),
                      itemBuilder: (context, index) {
                        final vehicle = filteredVehicles[index];
                        final image =
                            vehicle.image.isNotEmpty
                                ? vehicle.image
                                : 'https://via.placeholder.com/150';

                        return TweenAnimationBuilder<Offset>(
                          tween: Tween<Offset>(
                            begin: const Offset(
                              1,
                              0,
                            ), // Slide from right to left
                            end: Offset.zero,
                          ),
                          duration: Duration(
                            milliseconds: 500 + index * 100,
                          ), // Staggered animation
                          curve: Curves.easeOut,
                          builder: (context, offset, child) {
                            return Transform.translate(
                              offset:
                                  offset *
                                  100, // Multiply to create visible distance
                              child: Opacity(
                                opacity: 1.0 - offset.dx.abs(),
                                child: child,
                              ),
                            );
                          },
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                          VehicleDetailPage(vehicle: vehicle),
                                ),
                              );
                            },
                            child: Hero(
                              tag: 'vehicle_${vehicle.id}',
                              child: Card(
                                color: Colors.blueGrey[50],
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                      ),
                                      child: Image.network(
                                        image,
                                        height: 140,
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Image.asset(
                                            'assets/vehicle.jpg',
                                            height: 140,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${vehicle.make} ${vehicle.model}',
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueGrey,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            '₹${vehicle.price}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
