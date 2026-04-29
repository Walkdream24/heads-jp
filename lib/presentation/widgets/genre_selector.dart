import 'package:flutter/material.dart';
import '../../domain/entities/event_entity.dart';

class GenreSelector extends StatelessWidget {
  final List<EventGenre> selectedGenres;
  final void Function(List<EventGenre>) onGenresChanged;

  const GenreSelector({
    super.key,
    required this.selectedGenres,
    required this.onGenresChanged,
  });

  // NONEを除外した選択可能なジャンルリスト
  static final List<EventGenre> _selectableGenres = EventGenre.values
      .where((genre) => genre != EventGenre.NONE)
      .toList();

  void _toggleGenre(EventGenre genre) {
    final updatedGenres = List<EventGenre>.from(selectedGenres);
    
    if (updatedGenres.contains(genre)) {
      updatedGenres.remove(genre);
    } else {
      updatedGenres.add(genre);
    }
    
    onGenresChanged(updatedGenres);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ジャンル（任意）',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _selectableGenres.map((genre) {
            final isSelected = selectedGenres.contains(genre);
            return _GenreChip(
              genre: genre,
              isSelected: isSelected,
              onTap: () => _toggleGenre(genre),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _GenreChip extends StatelessWidget {
  final EventGenre genre;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenreChip({
    required this.genre,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? Colors.white 
              : const Color.fromARGB(255, 24, 24, 24),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          genre.displayName,
          style: TextStyle(
            color: isSelected 
                ? Colors.black 
                : const Color.fromARGB(255, 149, 149, 149),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}