import 'package:flutter/material.dart';

void main() => runApp(const PustakaDigitalApp());

class PustakaDigitalApp extends StatefulWidget {
  const PustakaDigitalApp({super.key});
  @override
  State<PustakaDigitalApp> createState() => _PustakaDigitalAppState();
}

class _PustakaDigitalAppState extends State<PustakaDigitalApp> {
  ThemeMode _themeMode = ThemeMode.light;
  void _toggleTheme() => setState(() => _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    const warmBrown = Color(0xFF8D6E63);
    const deepGrey = Color(0xFF1A1A1A);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: warmBrown, 
          primary: warmBrown, 
          surface: const Color(0xFFF8F9FA), 
          brightness: Brightness.light
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: deepGrey,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD7CCC8), 
          surface: Color(0xFF262626), 
          brightness: Brightness.dark
        ),
      ),
      home: HomeScreen(onThemeToggle: _toggleTheme, currentMode: _themeMode),
    );
  }
}

class Book {
  final int id;
  String title, author, category, description, image;
  int price, quantity;
  bool isFavorite;

  Book({required this.id, required this.title, required this.author, required this.price, required this.category, required this.description, required this.image, this.quantity = 1, this.isFavorite = false});
  Book copy() => Book(id: id, title: title, author: author, price: price, category: category, description: description, image: image, quantity: quantity, isFavorite: isFavorite);
}

class HomeScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final ThemeMode currentMode;
  const HomeScreen({super.key, required this.onThemeToggle, required this.currentMode});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedPayment = "E-Wallet (OVO/Gopay)"; 
  List<Book> cart = [];
  String activeCategory = "Semua";
  String searchTerm = "";
  final List<String> categories = ["Semua", "Fiksi", "Bisnis", "Sejarah", "Cerpen"];

  // FITUR STREAK
  int streakCount = 1;
  DateTime? lastLogin;

  @override
  void initState() {
    super.initState();
    _checkStreak();
  }

  void _checkStreak() {
    // Simulasi data dari penyimpanan lokal (SharedPreferences)
    // Di aplikasi nyata, Anda akan mengambil nilai ini dari database/disk
    DateTime today = DateTime.now();
    
    // Logika Streak Sederhana:
    // Jika login terakhir adalah kemarin, streak +1
    // Jika login terakhir adalah hari ini, streak tetap
    // Jika login terakhir lebih dari kemarin, streak reset ke 1
    
    setState(() {
      // Dummy: Kita anggap login terakhir adalah kemarin untuk demonstrasi
      lastLogin = DateTime.now().subtract(const Duration(days: 1)); 
      
      if (lastLogin != null) {
        final difference = today.difference(lastLogin!).inDays;
        if (difference == 1) {
          streakCount = 5; // Contoh: User sudah punya 5 streak
          streakCount++; 
        } else if (difference > 1) {
          streakCount = 1;
        }
      }
    });
  }

  // DAFTAR BUKU (25 Buku Tetap Sama)
  List<Book> books = [
    Book(id: 1, title: "Filosofi Teras", author: "Henry Manampiring", price: 98000, category: "Fiksi", description: "Penerapan stoisisme dalam kehidupan modern.", image: "https://images.unsplash.com/photo-1544947950-fa07a98d237f?q=80&w=400"),
    Book(id: 2, title: "Laskar Pelangi", author: "Andrea Hirata", price: 85000, category: "Fiksi", description: "Perjuangan anak-anak Belitong mengejar mimpi.", image: "https://images.unsplash.com/photo-1531346878377-a5be20888e57?q=80&w=400"),
    Book(id: 3, title: "Laut Bercerita", author: "Leila S. Chudori", price: 115000, category: "Fiksi", description: "Kisah pilu aktivis di era orde baru.", image: "https://images.unsplash.com/photo-1512820790803-83ca734da794?q=80&w=400"),
    Book(id: 4, title: "Cantik Itu Luka", author: "Eka Kurniawan", price: 135000, category: "Fiksi", description: "Epos keluarga yang penuh kutukan.", image: "https://images.unsplash.com/photo-1476275466078-4007374efbbe?q=80&w=400"),
    Book(id: 5, title: "Bumi Manusia", author: "Pramoedya Ananta Toer", price: 145000, category: "Fiksi", description: "Kisah cinta di era kolonial.", image: "https://images.unsplash.com/photo-1543004629-1420f545a133?q=80&w=400"),
    Book(id: 6, title: "Atomic Habits", author: "James Clear", price: 125000, category: "Bisnis", description: "Perubahan kecil yang luar biasa.", image: "https://images.unsplash.com/photo-1589829085413-56de8ae18c73?q=80&w=400"),
    Book(id: 7, title: "Rich Dad Poor Dad", author: "Robert Kiyosaki", price: 95000, category: "Bisnis", description: "Pelajaran finansial untuk kaya.", image: "https://images.unsplash.com/photo-1592492159418-39f319320569?q=80&w=400"),
    Book(id: 8, title: "Start With Why", author: "Simon Sinek", price: 105000, category: "Bisnis", description: "Cara pemimpin menginspirasi tindakan.", image: "https://images.unsplash.com/photo-1553729459-efe14ef6055d?q=80&w=400"),
    Book(id: 9, title: "The Lean Startup", author: "Eric Ries", price: 140000, category: "Bisnis", description: "Membangun bisnis secara efisien.", image: "https://images.unsplash.com/photo-1522202176988-66273c2fd55f?q=80&w=400"),
    Book(id: 10, title: "Zero to One", author: "Peter Thiel", price: 130000, category: "Bisnis", description: "Membangun masa depan melalui startup.", image: "https://images.unsplash.com/photo-1519389950473-47ba0277781c?q=80&w=400"),
    Book(id: 11, title: "Sapiens", author: "Yuval Noah Harari", price: 150000, category: "Sejarah", description: "Riwayat singkat umat manusia.", image: "https://images.unsplash.com/photo-1532012197267-da84d127e765?q=80&w=400"),
    Book(id: 12, title: "Guns, Germs & Steel", author: "Jared Diamond", price: 165000, category: "Sejarah", description: "Nasib masyarakat manusia.", image: "https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?q=80&w=400"),
    Book(id: 13, title: "History of Java", author: "Thomas S. Raffles", price: 350000, category: "Sejarah", description: "Karya agung tentang sejarah Jawa.", image: "https://images.unsplash.com/photo-1516979187457-637abb4f9353?q=80&w=400"),
    Book(id: 14, title: "Silk Roads", author: "Peter Frankopan", price: 180000, category: "Sejarah", description: "Sejarah baru dunia melalui jalur sutra.", image: "https://images.unsplash.com/photo-1463320435677-4702950567f6?q=80&w=400"),
    Book(id: 15, title: "Meditations", author: "Marcus Aurelius", price: 89000, category: "Sejarah", description: "Pemikiran sang Kaisar Roma.", image: "https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?q=80&w=400"),
    Book(id: 16, title: "Malam Malam Dingin", author: "Sapardi Djoko Damono", price: 65000, category: "Cerpen", description: "Kumpulan cerita yang menyentuh hati.", image: "https://images.unsplash.com/photo-1495446815901-a7297e633e8d?q=80&w=400"),
    Book(id: 17, title: "Robohnya Surau Kami", author: "A.A. Navis", price: 55000, category: "Cerpen", description: "Karya legendaris sastra Indonesia.", image: "https://images.unsplash.com/photo-1516414447565-b14be0adf13e?q=80&w=400"),
    Book(id: 18, title: "Corat-Coret di Toilet", author: "Eka Kurniawan", price: 72000, category: "Cerpen", description: "Kritik sosial yang tajam dan lucu.", image: "https://images.unsplash.com/photo-1521056787327-165dc2aee25e?q=80&w=400"),
    Book(id: 19, title: "Saksi Mata", author: "Seno Gumira Ajidarma", price: 68000, category: "Cerpen", description: "Cerita tentang kemanusiaan.", image: "https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?q=80&w=400"),
    Book(id: 20, title: "Dilarang Mencintai Bunga", author: "Kuntowijoyo", price: 60000, category: "Cerpen", description: "Eksplorasi batin manusia.", image: "https://images.unsplash.com/photo-1506466010722-395aa2bef877?q=80&w=400"),
    Book(id: 21, title: "Deep Work", author: "Cal Newport", price: 110000, category: "Bisnis", description: "Fokus di dunia yang penuh distraksi.", image: "https://images.unsplash.com/photo-1531206715517-5c0ba140b2b8?q=80&w=400"),
    Book(id: 22, title: "The Alchemist", author: "Paulo Coelho", price: 88000, category: "Fiksi", description: "Mengejar legenda pribadi kita.", image: "https://images.unsplash.com/photo-1589998059171-988d887df646?q=80&w=400"),
    Book(id: 23, title: "Gadis Kretek", author: "Ratih Kumala", price: 92000, category: "Fiksi", description: "Sejarah industri kretek di Indonesia.", image: "https://images.unsplash.com/photo-1513001900722-370f803f498d?q=80&w=400"),
    Book(id: 24, title: "Dunia Sophie", author: "Jostein Gaarder", price: 160000, category: "Fiksi", description: "Novel tentang sejarah filsafat.", image: "https://images.unsplash.com/photo-1525201548942-d8b8c09ec8d5?q=80&w=400"),
    Book(id: 25, title: "Madilog", author: "Tan Malaka", price: 120000, category: "Sejarah", description: "Pemikiran materialisme, dialektika, dan logika.", image: "https://images.unsplash.com/photo-1491843351663-7c116e35e8b5?q=80&w=400"),
  ];

  List<Book> get filteredBooks => books.where((b) => (activeCategory == "Semua" || b.category == activeCategory) && b.title.toLowerCase().contains(searchTerm.toLowerCase())).toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Text("Pustaka Kita.", style: TextStyle(fontWeight: FontWeight.w900, color: theme.colorScheme.primary, fontSize: 24)),
            const SizedBox(width: 12),
            // TAMPILAN STREAK ALA TIKTOK
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department, color: Colors.orange, size: 18),
                  const SizedBox(width: 4),
                  Text("$streakCount", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: widget.onThemeToggle, icon: Icon(widget.currentMode == ThemeMode.dark ? Icons.wb_sunny_outlined : Icons.nightlight_round_outlined)),
          _buildCartBadge(theme),
          const SizedBox(width: 10),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildSearchBar(theme),
                    _buildTopPromotion(theme),
                    _buildCategoryBadges(theme),
                    const SizedBox(height: 10),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500), 
                      child: _buildGrid(theme, constraints.maxWidth)
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: "Jelajah"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profil"),
        ],
      ),
    );
  }

  // --- WIDGET LAINNYA TETAP SAMA SEPERTI SEBELUMNYA ---

  Widget _buildSearchBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: TextField(
          onChanged: (v) => setState(() => searchTerm = v),
          decoration: InputDecoration(
            hintText: "Mau baca apa hari ini?", 
            prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary), 
            filled: true, 
            fillColor: theme.colorScheme.surface, 
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildTopPromotion(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 180, 
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), 
        image: const DecorationImage(
          image: NetworkImage("https://images.unsplash.com/photo-1507842217343-583bb7270b66?q=80&w=1200"), 
          fit: BoxFit.cover
        )
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), 
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.8), Colors.transparent], 
            begin: Alignment.centerLeft
          )
        ),
        padding: const EdgeInsets.all(25),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.yellow[700], borderRadius: BorderRadius.circular(8)),
            child: const Text("PROMO TERBATAS", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10)),
          ),
          const SizedBox(height: 10),
          const Text("Diskon Hingga 50%", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const Text("Khusus koleksi buku Fiksi pilihan", style: TextStyle(color: Colors.white70, fontSize: 14)),
        ]),
      ),
    );
  }

  Widget _buildCategoryBadges(ThemeData theme) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: categories.map((cat) {
          bool sel = activeCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(cat),
              selected: sel,
              onSelected: (v) => setState(() => activeCategory = cat),
              selectedColor: theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.surface,
              labelStyle: TextStyle(color: sel ? Colors.white : theme.colorScheme.onSurface, fontWeight: sel ? FontWeight.bold : FontWeight.normal),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGrid(ThemeData theme, double screenWidth) {
    int crossAxisCount = screenWidth > 900 ? 5 : (screenWidth > 600 ? 3 : 2);
    return GridView.builder(
      key: ValueKey(activeCategory + searchTerm + crossAxisCount.toString()),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount, 
        childAspectRatio: 0.65, 
        crossAxisSpacing: 15, 
        mainAxisSpacing: 15
      ),
      itemCount: filteredBooks.length,
      itemBuilder: (context, i) {
        final b = filteredBooks[i];
        return InkWell( 
          onTap: () => _showDetail(b),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), 
                      child: Image.network(b.image, fit: BoxFit.cover, width: double.infinity, height: double.infinity)
                    ),
                    Positioned(
                      top: 8, left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.9), borderRadius: BorderRadius.circular(6)),
                        child: Text(b.category, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(b.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(b.author, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Rp ${b.price}", style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w900, fontSize: 13)),
                        const Icon(Icons.add_circle, size: 20, color: Colors.grey),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
        );
      },
    );
  }

  Widget _buildCartBadge(ThemeData theme) {
    return InkWell(
      onTap: _showCartDrawer,
      borderRadius: BorderRadius.circular(50),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Stack(alignment: Alignment.center, children: [
          const Icon(Icons.shopping_bag_outlined, size: 26),
          if (cart.isNotEmpty) Positioned(right: 0, top: 0, child: CircleAvatar(radius: 7, backgroundColor: Colors.orange[800], child: Text(cart.length.toString(), style: const TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold)))),
        ]),
      ),
    );
  }

  void _showDetail(Book b) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: const BoxConstraints(maxWidth: 500), 
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(25),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
          const SizedBox(height: 20),
          ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.network(b.image, height: 250)),
          const SizedBox(height: 20),
          Text(b.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(b.author, style: TextStyle(color: Colors.grey[600], fontSize: 16)),
          const SizedBox(height: 15),
          Text(b.description, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[700])),
          const SizedBox(height: 25),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 55), 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
            ),
            onPressed: () { setState(() => cart.add(b.copy())); Navigator.pop(context); }, 
            child: const Text("Tambah ke Keranjang", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
          ),
        ]),
      ),
    );
  }

  void _showCartDrawer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: const BoxConstraints(maxWidth: 500), 
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          int total = cart.fold(0, (sum, item) => sum + item.price);
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(25),
            child: Column(children: [
              const Text("Keranjang Belanja", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const Divider(height: 30),
              Expanded(
                child: cart.isEmpty 
                  ? const Center(child: Text("Wah, keranjangmu masih kosong!")) 
                  : ListView.builder(
                      itemCount: cart.length,
                      itemBuilder: (context, i) => Card(
                        elevation: 0,
                        color: Theme.of(context).colorScheme.surface,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(cart[i].image, width: 45, fit: BoxFit.cover)),
                          title: Text(cart[i].title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("Rp ${cart[i].price}"),
                          trailing: IconButton(icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent), onPressed: () {
                            setState(() => cart.removeAt(i));
                            setModalState(() {});
                          }),
                        ),
                      ),
                    ),
              ),
              if (cart.isNotEmpty) ...[
                const Divider(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text("Total:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Rp $total", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                ]),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 60), backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  onPressed: () { Navigator.pop(context); _showCheckoutScreen(); }, 
                  child: const Text("Lanjut Checkout", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                ),
              ]
            ]),
          );
        },
      ),
    );
  }

  void _showCheckoutScreen() {
    int subtotal = cart.fold(0, (sum, item) => sum + item.price);
    int total = subtotal + 2500;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: const BoxConstraints(maxWidth: 500),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.all(30),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("Checkout", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 25),
            _rowPrice("Subtotal", subtotal),
            _rowPrice("Biaya Layanan", 2500),
            const Divider(height: 30),
            _rowPrice("Total Pembayaran", total, isBold: true),
            const SizedBox(height: 35),
            const Text("Metode Pembayaran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 15),
            _paymentOption(Icons.account_balance_wallet, "E-Wallet (OVO/Gopay)", setModalState),
            _paymentOption(Icons.account_balance, "Transfer Bank", setModalState),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 65), backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              onPressed: () => _processPayment(), 
              child: Text("Bayar Sekarang ($selectedPayment)", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
            ),
          ]),
        ),
      ),
    );
  }

  Widget _rowPrice(String label, int price, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(fontSize: isBold ? 18 : 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text("Rp $price", style: TextStyle(fontSize: isBold ? 18 : 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      ]),
    );
  }

  Widget _paymentOption(IconData icon, String label, StateSetter setModalState) {
    bool isSelected = selectedPayment == label;
    return GestureDetector(
      onTap: () => setModalState(() => selectedPayment = label),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.withOpacity(0.3), width: 2),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.05) : Colors.transparent,
        ),
        child: Row(children: [
          Icon(icon, color: isSelected ? Theme.of(context).colorScheme.primary : null),
          const SizedBox(width: 15),
          Text(label, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 15)),
          const Spacer(),
          Icon(isSelected ? Icons.check_circle : Icons.circle_outlined, color: isSelected ? Theme.of(context).colorScheme.primary : null),
        ]),
      ),
    );
  }

  void _processPayment() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Container(
          width: 400, 
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 900),
              curve: Curves.elasticOut,
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Colors.white, size: 60),
              ),
            ),
            const SizedBox(height: 25),
            const Text("Pembayaran Berhasil!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Terima kasih telah berbelanja.\nMetode: $selectedPayment", textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () { 
                setState(() => cart.clear());
                Navigator.pop(context); 
              }, 
              child: const Text("Selesai")
            )
          ]),
        ),
      ),
    );
  }
}