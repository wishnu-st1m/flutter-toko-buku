import 'package:flutter/material.dart';

void main() {
  runApp(const PustakaDigitalApp());
}

class PustakaDigitalApp extends StatelessWidget {
  const PustakaDigitalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pustaka Digital',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        fontFamily: 'Sans', // Pastikan font terdaftar jika ingin persis
      ),
      home: const HomeScreen(),
    );
  }
}

// 1. Model Data
class Book {
  final int id;
  String title;
  String author;
  int price;
  String category;
  double rating;
  String description;
  String image;
  int quantity;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    required this.category,
    this.rating = 4.5,
    required this.description,
    required this.image,
    this.quantity = 1,
  });

  // Helper untuk copy object (mirip spread operator di React)
  Book copy() => Book(
        id: id,
        title: title,
        author: author,
        price: price,
        category: category,
        rating: rating,
        description: description,
        image: image,
        quantity: quantity,
      );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 2. State (Mirip useState di React)
  List<Book> books = [
    Book(
      id: 1,
      title: "Filosofi Teras",
      author: "Henry Manampiring",
      price: 98000,
      category: "Fiksi",
      rating: 4.8,
      description: "Buku yang memperkenalkan stoisisme untuk mental yang lebih tangguh.",
      image: "https://images.unsplash.com/photo-1544947950-fa07a98d237f?auto=format&fit=crop&q=80&w=400",
    ),
    Book(
      id: 2,
      title: "Atomic Habits",
      author: "James Clear",
      price: 125000,
      category: "Bisnis",
      rating: 4.9,
      description: "Cara mudah untuk membangun kebiasaan baik dan menghilangkan kebiasaan buruk.",
      image: "https://images.unsplash.com/photo-1589829085413-56de8ae18c73?auto=format&fit=crop&q=80&w=400",
    ),
    Book(
      id: 3,
      title: "Seni Berperang",
      author: "Sun Tzu",
      price: 55000,
      category: "Sejarah",
      rating: 4.7,
      description: "Strategi klasik militer Cina yang relevan untuk bisnis dan kehidupan.",
      image: "https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&q=80&w=400",
    ),
  ];

  List<Book> cart = [];
  String activeCategory = "Semua";
  String searchTerm = "";
  final List<String> categories = ["Semua", "Fiksi", "Bisnis", "Teknologi", "Sejarah"];

  // 3. Logika (Mirip useMemo/Functions di React)
  List<Book> get filteredBooks {
    return books.where((book) {
      bool matchesSearch = book.title.toLowerCase().contains(searchTerm.toLowerCase()) ||
          book.author.toLowerCase().contains(searchTerm.toLowerCase());
      bool matchesCategory = activeCategory == "Semua" || book.category == activeCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void addToCart(Book book) {
    setState(() {
      int index = cart.indexWhere((item) => item.id == book.id);
      if (index != -1) {
        cart[index].quantity++;
      } else {
        cart.add(book.copy());
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Buku ditambahkan ke keranjang'), duration: Duration(seconds: 1)),
    );
  }

  void removeFromCart(int id) {
    setState(() {
      cart.removeWhere((item) => item.id == id);
    });
  }

  int get totalPrice => cart.fold(0, (sum, item) => sum + (item.price * item.quantity));
  int get totalItems => cart.fold(0, (sum, item) => sum + item.quantity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("PustakaDigital", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () => _showAddBookDialog(),
            icon: const Icon(Icons.add_circle_outline, color: Colors.green),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () => _showCartDrawer(),
                icon: const Icon(Icons.shopping_cart_outlined),
              ),
              if (totalItems > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text(
                      totalItems.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
            ],
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Hero Section
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              color: const Color(0xFF0F172A),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Katalog Digital Terupdate", style: TextStyle(color: Colors.indigoAccent, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text("Baca Buku Jadi Lebih Seru", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.black)),
                  const SizedBox(height: 12),
                  Text("Koleksi buku premium yang bisa kamu kelola sendiri.", style: TextStyle(color: Colors.blueGrey[200])),
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: (val) => setState(() => searchTerm = val),
                    decoration: InputDecoration(
                      hintText: "Cari koleksi buku...",
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                    ),
                  )
                ],
              ),
            ),
          ),
          // Category Selector
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Row(
                children: categories.map((cat) {
                  bool isSelected = activeCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (val) => setState(() => activeCategory = cat),
                      selectedColor: Colors.indigo,
                      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Book Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final book = filteredBooks[index];
                  return _buildBookCard(book);
                },
                childCount: filteredBooks.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildBookCard(Book book) {
    return GestureDetector(
      onTap: () => _showBookDetail(book),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: Image.network(book.image, width: double.infinity, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(book.category.toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.indigo, fontWeight: FontWeight.bold)),
                  Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      Text("Rp ${book.price}", style: const TextStyle(fontWeight: FontWeight.black, color: Colors.indigo)),
                      const Icon(Icons.add_circle, color: Colors.indigo, size: 24),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Modal UI Helpers (Mirip Modal di React)
  void _showBookDetail(Book book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(book.image, height: 250, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.between,
              children: [
                Expanded(child: Text(book.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.black))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(12)),
                  child: Row(children: [const Icon(Icons.star, size: 16), Text(book.rating.toString())]),
                )
              ],
            ),
            Text("Oleh ${book.author}", style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),
            Text(book.description, style: const TextStyle(color: Colors.grey)),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                addToCart(book);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text("Beli Sekarang", style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  void _showCartDrawer() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(0))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Keranjang", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Expanded(
                child: cart.isEmpty
                    ? const Center(child: Text("Belum ada buku nih..."))
                    : ListView.builder(
                        itemCount: cart.length,
                        itemBuilder: (context, index) {
                          final item = cart[index];
                          return ListTile(
                            leading: Image.network(item.image, width: 50, fit: BoxFit.cover),
                            title: Text(item.title, maxLines: 1),
                            subtitle: Text("Rp ${item.price}"),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                removeFromCart(item.id);
                                setModalState(() {});
                                setState(() {});
                              },
                            ),
                          );
                        },
                      ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  const Text("Total"),
                  Text("Rp $totalPrice", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: cart.isEmpty ? null : () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text("Selesaikan Pembayaran"),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showAddBookDialog() {
    final titleCtrl = TextEditingController();
    final authorCtrl = TextEditingController();
    final priceCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Buku Baru"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Judul")),
              TextField(controller: authorCtrl, decoration: const InputDecoration(labelText: "Penulis")),
              TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: "Harga"), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                books.add(Book(
                  id: DateTime.now().millisecondsSinceEpoch,
                  title: titleCtrl.text,
                  author: authorCtrl.text,
                  price: int.parse(priceCtrl.text),
                  category: "Fiksi",
                  description: "Deskripsi buku baru...",
                  image: "https://images.unsplash.com/photo-1544947950-fa07a98d237f?auto=format&fit=crop&q=80&w=400",
                ));
              });
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          )
        ],
      ),
    );
  }
}