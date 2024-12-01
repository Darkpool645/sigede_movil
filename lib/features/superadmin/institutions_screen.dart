import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sigede_movil/core/models/institution_model.dart';
import 'package:sigede_movil/core/services/institutes_service.dart';
import 'package:sigede_movil/config/dio_client.dart';

class InstitutionsScreen extends StatefulWidget {
  const InstitutionsScreen({super.key});

  @override
  _InstitutionsScreenState createState() => _InstitutionsScreenState();
}

class _InstitutionsScreenState extends State<InstitutionsScreen> {
  final InstitutionService _institutionService = InstitutionService(DioClient());
  final List<Institution> _institutions = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  final int _pageSize = 10;
  String _searchQuery = '';
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchInstitutions();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
        !_isLoading &&
        _hasMore) {
      _fetchInstitutions();
    }
  }

  Future<void> _fetchInstitutions() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final institutions = await _institutionService.fetchInstitutions(_currentPage, _pageSize);

      setState(() {
        _institutions.addAll(institutions);
        _currentPage++;
        _hasMore = institutions.length == _pageSize;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch institutions: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchInstitutions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final institutions = await _institutionService.fetchInstitutionsByName(
        _currentPage,
        _pageSize,
        _searchQuery,
      );

      setState(() {
        _institutions.clear(); // Limpiamos la lista antes de mostrar los nuevos resultados
        _institutions.addAll(institutions);
        _currentPage = 1; // Reiniciamos la página a la primera
        _hasMore = institutions.length == _pageSize; // Verificamos si hay más resultados
      });

      if (institutions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontraron instituciones')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al buscar instituciones: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
      _currentPage = 0;
      _fetchInstitutions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool showEmptyState = _institutions.isEmpty && !_isLoading;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Clientes",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            const SizedBox(height: 16),
            // TextField con icono de búsqueda y X para borrar
            TextField(
              controller: _searchController,
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar cliente',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: Colors.brown, width: 1.5),
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearSearch,
                      )
                    : null, // Mostrar la X solo si hay texto en el campo
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 16),
            // Botón para activar la búsqueda
            ElevatedButton(
              onPressed: _searchInstitutions,
              child: const Text("Buscar"),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshInstitutions, // Función de refresco
                child: showEmptyState
                    ? _buildEmptyState() // Mostrar estado vacío
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: _institutions.length +
                            (_isLoading || _hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _institutions.length) {
                            return _isLoading
                                ? _buildShimmerCard()
                                : const SizedBox.shrink();
                          }
                          return _buildInstitutionCard(_institutions[index]);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshInstitutions() async {
    // Reinicia la lista y otros estados
    setState(() {
      _institutions.clear();
      _currentPage = 0;
      _hasMore = true;
    });

    // Vuelve a cargar los datos
    await _fetchInstitutions();
  }

  Widget _buildInstitutionCard(Institution institution) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                institution.logo,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    institution.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    institution.address,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 16,
                          width: double.infinity,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 14,
                          width: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 12,
                          width: 150,
                          color: Colors.grey[300],
                        ),
                      ],
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No se encontraron registros',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
