import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:serenypals_frontend/utils/color.dart';
import '../../blocs/virtual_pet/pet_bloc.dart';
import '../../blocs/virtual_pet/pet_event.dart';
import '../../blocs/virtual_pet/pet_state.dart';

class VirtualPetPage extends StatelessWidget {
  const VirtualPetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F0E1),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.go('/dashboard'); // Kembali ke halaman utama
          },
        ),
        actions: [
          _buildPointsContainer(
            icon: Icons.star,
            color: Colors.yellow,
            value: '999',
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              context.go('/anabul/topup');
            },
            child: _buildPointsContainer(
              icon: Icons.diamond,
              color: Colors.blueAccent,
              value: '999',
              showAdd: true,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            MusicToggleButton(),
                            SizedBox(height: 20),
                            PetName(),
                            SizedBox(height: 30),
                            PetImage(),
                            SizedBox(height: 20),
                            PetStats(),
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                      const PetActions(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPointsContainer({
    required IconData icon,
    required Color color,
    required String value,
    bool showAdd = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color3,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          if (showAdd) ...[
            const SizedBox(width: 5),
            const Icon(Icons.add, color: Colors.black, size: 18),
          ],
        ],
      ),
    );
  }
}

class MusicToggleButton extends StatelessWidget {
  const MusicToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: BlocBuilder<PetBloc, PetState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  state.pet.isMusicPlaying ? Icons.music_note : Icons.music_off,
                  color: Colors.black,
                ),
                onPressed: () {
                  context.read<PetBloc>().add(PetToggleMusic());
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class PetName extends StatelessWidget {
  const PetName({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetBloc, PetState>(
      builder: (context, state) {
        return Text(
          state.pet.name,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        );
      },
    );
  }
}

class PetImage extends StatelessWidget {
  const PetImage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetBloc, PetState>(
      builder: (context, state) {
        return Image.asset(
          'assets/img/capybara_pet.png',
          width: 250,
          height: 250,
        );
      },
    );
  }
}

class PetStats extends StatelessWidget {
  const PetStats({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetBloc, PetState>(
      builder: (context, state) {
        return Column(
          children: [
            Text('Energy: ${state.pet.energy.toStringAsFixed(0)}'),
            Text('Hunger: ${state.pet.hunger.toStringAsFixed(0)}'),
          ],
        );
      },
    );
  }
}

class PetActions extends StatelessWidget {
  const PetActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: BlocBuilder<PetBloc, PetState>(
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(
                context,
                Icons.fastfood,
                'Makan',
                state.pet.hunger,
                state.pet.energy,
                () => context.read<PetBloc>().add(PetStartEating()),
                state.pet.currentAnimation == 'eating',
                Colors.orange,
              ),
              _buildActionButton(
                context,
                Icons.directions_walk,
                'Main',
                state.pet.hunger,
                state.pet.energy,
                () => context.read<PetBloc>().add(PetStartPlaying()),
                state.pet.currentAnimation == 'playing',
                Colors.green,
              ),
              _buildActionButton(
                context,
                Icons.nightlight_round,
                'Tidur',
                state.pet.hunger,
                state.pet.energy,
                () => context.read<PetBloc>().add(PetStartSleeping()),
                state.pet.currentAnimation == 'sleeping',
                Colors.deepPurple,
              ),
              _buildActionButton(
                context,
                Icons.store,
                'Toko',
                100,
                100,
                () {}, // belum ada action toko
                false,
                Colors.blueGrey,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    double currentHunger,
    double currentEnergy,
    VoidCallback onPressed,
    bool isActive,
    Color activeColor,
  ) {
    return AnimatedActionButton(
      icon: icon,
      label: label,
      onPressed: onPressed,
      isActive: isActive,
      color: activeColor,
    );
  }
}

class AnimatedActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isActive;
  final Color color;

  const AnimatedActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.isActive,
    required this.color,
  });

  @override
  State<AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<AnimatedActionButton> {
  double _offsetY = 0;
  Color _iconColor = Colors.blue.shade800;

  @override
  void didUpdateWidget(covariant AnimatedActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Trigger animation when active state changes
    if (widget.isActive) {
      setState(() {
        _offsetY = -10;
        _iconColor = widget.color;
      });

      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _offsetY = 0;
          _iconColor = Colors.blue.shade800;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(40),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(0, _offsetY, 0),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                if (widget.isActive)
                  BoxShadow(
                    color: widget.color.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
              ],
            ),
            child: Icon(
              widget.icon,
              size: 30,
              color: _iconColor,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.label,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
