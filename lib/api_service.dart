import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> fetchSummonerRank(String summonerName) async {
  final String apiKey = 'RGAPI-274cf6df-0a89-46a1-b047-7204996bbf64';
  final String region = 'euw1';

  final encodedSummonerName = Uri.encodeComponent(summonerName);

  final response = await http.get(Uri.parse(
      'https://$region.api.riotgames.com/lol/summoner/v4/summoners/by-name/$encodedSummonerName?api_key=$apiKey'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> summonerData = jsonDecode(response.body);
    final String summonerId = summonerData['id'];

    final leagueResponse = await http.get(Uri.parse(
        'https://$region.api.riotgames.com/lol/league/v4/entries/by-summoner/$summonerId?api_key=$apiKey'));

    if (leagueResponse.statusCode == 200) {
      final List<dynamic> leagueData = jsonDecode(leagueResponse.body);

      // Permet d'afficher ce que contient leagueData
      print('Contenu de leagueData: $leagueData');

      // Filtrer les données de classement pour le mode de jeu "RANKED_SOLO_5x5"
      final soloQueueData = leagueData
          .where((entry) => entry['queueType'] == 'RANKED_SOLO_5x5')
          .toList();

      // Vérifier si des données sont présentes pour le mode de jeu "RANKED_SOLO_5x5"
      if (soloQueueData.isNotEmpty) {
        // Récupérer le rang dans le mode de jeu "RANKED_SOLO_5x5"
        final String tier = soloQueueData[0]['tier'];
        final String division = soloQueueData[0]['rank'];
        final int points = soloQueueData[0]['leaguePoints'];
        return '$tier $division $points LPs';
      } else {
        throw Exception('Ranked solo queue data not found');
      }
    } else {
      throw Exception('Failed to load summoner league data');
    }
  } else {
    throw Exception('Failed to load summoner data');
  }
}
