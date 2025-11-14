import 'package:flutter/material.dart';

class VoteScreen extends StatelessWidget {
  const VoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      appBar: AppBar(
        title: const Text(
          'Concours Miss Togo 2024',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // 🔥 Encadré dégradé "Classement des votes"
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff9b2cf0), Color(0xffe639c7)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.bar_chart, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Classement des Votes",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    "7 315 votes au total",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔱 TOP 3
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTopCandidate(
                  image: "https://i.imgur.com/AKdB9s1.png",
                  name: "Efua Ablavi",
                  votes: 1156,
                ),
                _buildTopCandidate(
                  image: "https://i.imgur.com/AKdB9s1.png",
                  name: "Akosua Mensah",
                  votes: 1247,
                  isWinner: true,
                ),
                _buildTopCandidate(
                  image: "https://i.imgur.com/AKdB9s1.png",
                  name: "Yawa Agbeko",
                  votes: 1089,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 🔽 Liste complète
            _buildRankTile(
              rank: 1,
              name: "Akosua Mensah",
              city: "Lomé",
              votes: 1247,
              percent: 17.0,
              image: "https://i.imgur.com/AKdB9s1.png",
            ),

            _buildRankTile(
              rank: 2,
              name: "Efua Ablavi",
              city: "Sokodé",
              votes: 1156,
              percent: 15.8,
              image: "https://i.imgur.com/AKdB9s1.png",
            ),

            _buildRankTile(
              rank: 3,
              name: "Yawa Agbeko",
              city: "Kpalimé",
              votes: 1089,
              percent: 14.2,
              image: "https://i.imgur.com/AKdB9s1.png",
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // 🔥 Widget Top 3 Cards
  Widget _buildTopCandidate({
    required String image,
    required String name,
    required int votes,
    bool isWinner = false,
  }) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: isWinner ? 45 : 40,
              backgroundImage: NetworkImage(image),
            ),
            if (isWinner)
              const Positioned(
                top: -2,
                right: -2,
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.yellow,
                  child: Icon(Icons.emoji_events, size: 18, color: Colors.white),
                ),
              )
          ],
        ),
        const SizedBox(height: 6),
        Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 3),
        Text("$votes votes", style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  // 🔥 Widget Liste des classements
  Widget _buildRankTile({
    required int rank,
    required String name,
    required String city,
    required int votes,
    required double percent,
    required String image,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 24, backgroundImage: NetworkImage(image)),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$rank. $name", style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(city, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 6),

                LinearProgressIndicator(
                  value: percent / 100,
                  minHeight: 6,
                  backgroundColor: Colors.pink.shade100,
                  valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Column(
            children: [
              const Icon(Icons.favorite, color: Colors.pink, size: 20),
              Text("$votes"),
            ],
          )
        ],
      ),
    );
  }
}