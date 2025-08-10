import 'package:flutter/material.dart';

void main() {
  runApp(const MeuDiaNaEstradaApp());
}

class MeuDiaNaEstradaApp extends StatelessWidget {
  const MeuDiaNaEstradaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu Dia na Estrada',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const HomeScreen(),
        '/fuel': (_) => const FuelScreen(),
        '/cargo': (_) => const CargoScreen(),
        '/activity': (_) => const ActivityScreen(),
        '/drivercard': (_) => const DriverCardScreen(),
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const Icon(Icons.local_shipping, size: 72),
              const SizedBox(height: 12),
              const Text('MEU DIA\nNA ESTRADA', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
              const SizedBox(height: 24),
              TextField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'E-mail'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha'),
              ),
              const Spacer(),
              FilledButton(
                onPressed: _loading ? null : () async {
                  setState(() => _loading = true);
                  await Future.delayed(const Duration(milliseconds: 500)); // fake auth
                  if (!mounted) return;
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: _loading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('ENTRAR'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Dia na Estrada')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HomeTile(icon: Icons.local_gas_station, title: 'Abastecimento', route: '/fuel'),
          _HomeTile(icon: Icons.inventory_2, title: 'Carga/Descarga', route: '/cargo'),
          _HomeTile(icon: Icons.assignment, title: 'Outra Atividade', route: '/activity'),
          _HomeTile(icon: Icons.badge, title: 'Cartão de Motorista', route: '/drivercard'),
        ],
      ),
    );
  }
}

class _HomeTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  const _HomeTile({required this.icon, required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}

String nowTime() {
  final now = DateTime.now();
  final hh = now.hour.toString().padLeft(2, '0');
  final mm = now.minute.toString().padLeft(2, '0');
  return '$hh:$mm';
}

class FuelScreen extends StatefulWidget {
  const FuelScreen({super.key});
  @override
  State<FuelScreen> createState() => _FuelScreenState();
}

class _FuelScreenState extends State<FuelScreen> {
  final _qty = TextEditingController();
  final _price = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Abastecimento')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _InfoRow(icon: Icons.access_time, label: nowTime()),
            const SizedBox(height: 8),
            const _InfoRow(icon: Icons.location_on, label: 'Localização Atual (simulado)'),
            const SizedBox(height: 12),
            TextField(
              controller: _qty,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Quantidade (L)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _price,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Preço (€)'),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Abastecimento salvo (local).')),
                );
                Navigator.pop(context);
              },
              child: const Text('SALVAR'),
            ),
          ],
        ),
      ),
    );
  }
}

class CargoScreen extends StatefulWidget {
  const CargoScreen({super.key});
  @override
  State<CargoScreen> createState() => _CargoScreenState();
}

class _CargoScreenState extends State<CargoScreen> {
  final _ref = TextEditingController();
  String _tipo = 'Carga';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carga/Descarga')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _InfoRow(icon: Icons.access_time, label: nowTime()),
            const SizedBox(height: 8),
            const _InfoRow(icon: Icons.location_on, label: 'Localização Atual (simulado)'),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _tipo,
              items: const [
                DropdownMenuItem(value: 'Carga', child: Text('Carga')),
                DropdownMenuItem(value: 'Descarga', child: Text('Descarga')),
              ],
              onChanged: (v) => setState(() => _tipo = v ?? 'Carga'),
              decoration: const InputDecoration(labelText: 'Tipo'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ref,
              decoration: const InputDecoration(labelText: 'Referência/Notas'),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$_tipo salva (local).')),
                );
                Navigator.pop(context);
              },
              child: const Text('SALVAR'),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});
  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final _desc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Outra Atividade')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _InfoRow(icon: Icons.access_time, label: nowTime()),
            const SizedBox(height: 8),
            const _InfoRow(icon: Icons.location_on, label: 'Localização Atual (simulado)'),
            const SizedBox(height: 12),
            TextField(
              controller: _desc,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Atividade salva (local).')),
                );
                Navigator.pop(context);
              },
              child: const Text('SALVAR'),
            ),
          ],
        ),
      ),
    );
  }
}

class DriverCardScreen extends StatefulWidget {
  const DriverCardScreen({super.key});
  @override
  State<DriverCardScreen> createState() => _DriverCardScreenState();
}

class _DriverCardScreenState extends State<DriverCardScreen> {
  bool? _inOut; // true = Entrada, false = Saída

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cartão de Motorista')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _InfoRow(icon: Icons.access_time, label: nowTime()),
            const SizedBox(height: 8),
            const _InfoRow(icon: Icons.location_on, label: 'Localização Atual (simulado)'),
            const SizedBox(height: 12),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, icon: Icon(Icons.login), label: Text('Entrada')),
                ButtonSegment(value: false, icon: Icon(Icons.logout), label: Text('Saída')),
              ],
              selected: _inOut == null ? <bool>{} : {_inOut!},
              onSelectionChanged: (s) => setState(() => _inOut = s.firstOrNull),
              multiSelectionEnabled: false,
              showSelectedIcon: false,
            ),
            const Spacer(),
            FilledButton(
              onPressed: _inOut == null ? null : () {
                final label = _inOut == true ? 'Entrada' : 'Saída';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$label registrada (local).')),
                );
                Navigator.pop(context);
              },
              child: const Text('SALVAR'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

extension FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}