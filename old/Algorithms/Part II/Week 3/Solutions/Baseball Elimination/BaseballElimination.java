/******************************************************************************
 * Author: Huang
 * Date: 22.01.27
 * Website: https://huang-feiyu.github.io
 * Description: BaseballElimination.java for algs4 homework-BaseballElimination
 ******************************************************************************/

import edu.princeton.cs.algs4.FlowEdge;
import edu.princeton.cs.algs4.FlowNetwork;
import edu.princeton.cs.algs4.FordFulkerson;
import edu.princeton.cs.algs4.In;
import edu.princeton.cs.algs4.Queue;
import edu.princeton.cs.algs4.StdOut;

import java.util.Arrays;
import java.util.HashMap;

public class BaseballElimination {
  private static final int SOURCE = 0;
  private static final int SINK = 1;
  private int sz; // team num
  private final int[] wins, loss, rest;
  private final int[][] game;
  private final String[] teams;
  private String tempWinner;
  private final HashMap<String, Integer> teamIndex = new HashMap<>();

  // create a baseball division from given filename in format specified below
  public BaseballElimination(String filename) {
    if (filename == null) throw new IllegalArgumentException();
    In file = new In(filename);
    sz = file.readInt(); // initialize
    wins = new int[sz];
    loss = new int[sz];
    rest = new int[sz];
    game = new int[sz][sz];
    teams = new String[sz];

    int maxWin = Integer.MIN_VALUE;
    for (int i = 0; i < sz; i++) { // read file
      teams[i] = file.readString();
      teamIndex.put(teams[i], i);
      wins[i] = file.readInt();
      loss[i] = file.readInt();
      rest[i] = file.readInt();
      for (int j = 0; j < sz; j++)
        game[i][j] = file.readInt();
      if (wins[i] > maxWin) {
        maxWin = wins[i];
        tempWinner = teams[i];
      }
    }
  }

  // number of teams
  public int numberOfTeams() {
    return sz;
  }

  // all teams
  public Iterable<String> teams() {
    return Arrays.asList(teams);
  }

  // number of wins for given team
  public int wins(String team) {
    validateTeam(team);
    return wins[teamIndex.get(team)];
  }

  // number of losses for given team
  public int losses(String team) {
    validateTeam(team);
    return loss[teamIndex.get(team)];
  }

  // number of remaining games for given team
  public int remaining(String team) {
    validateTeam(team);
    return rest[teamIndex.get(team)];
  }

  // number of remaining games between team1 and team2
  public int against(String team1, String team2) {
    validateTeam(team1);
    validateTeam(team2);
    return game[teamIndex.get(team1)][teamIndex.get(team2)];
  }

  // is given team eliminated?
  public boolean isEliminated(String team) {
    validateTeam(team);
    return isTrivialElimination(team) || isNonTrivialElimination(team);
  }

  // is trivial elimination
  private boolean isTrivialElimination(String team) {
    if (team.equals(tempWinner)) return false;
    return wins(team) + remaining(team) < wins(tempWinner);
  }

  // is non-trivial elimination
  private boolean isNonTrivialElimination(String team) {
    FlowNetwork network = getFlowNetwork(team);
    getFordFulkerson(network);
    for (FlowEdge edge : network.adj(SOURCE))
      if (edge.flow() < edge.capacity()) // with best luck, it still loses
        return true;
    return false;
  }

  // constructor to flowNetwork: to specific x/team
  private FlowNetwork getFlowNetwork(String team) {
    FlowNetwork network = new FlowNetwork(2 + (sz - 1) * sz / 2 + sz);
    int gameVertex = 2; // 0 is source, 1 is sink; initially 2
    int x = teamIndex.get(team);

    for (int i = 0; i < sz; i++) {
      if (i == x) continue;
      for (int j = i + 1; j < sz; j++) {
        if (j == x) continue;
        int team1 = getTeamVertex(i);
        int team2 = getTeamVertex(j);

        // source to game-vertex
        FlowEdge edge = new FlowEdge(SOURCE, gameVertex, game[i][j]);
        network.addEdge(edge);

        // team-vertex to THE two teams
        edge = new FlowEdge(gameVertex, team1, Double.POSITIVE_INFINITY);
        network.addEdge(edge);
        edge = new FlowEdge(gameVertex, team2, Double.POSITIVE_INFINITY);
        network.addEdge(edge);

        gameVertex++;
      }
    }
    int wx = wins(team);
    int rx = remaining(team);
    for (int i = 0; i < sz; i++) {
      if (i == x) continue;
      int capacity = wx + rx - wins(teams[i]);
      FlowEdge edge = new FlowEdge(getTeamVertex(i), SINK, capacity);
      network.addEdge(edge);
    }
    return network;
  }

  // get ford-fulkerson
  private FordFulkerson getFordFulkerson(FlowNetwork network) {
    return new FordFulkerson(network, SOURCE, SINK);
  }

  // team vertex
  private int getTeamVertex(int i) {
    return 2 + (sz - 1) * sz / 2 + i;
  }

  // subset R of teams that eliminates given team; null if not eliminated
  public Iterable<String> certificateOfElimination(String team) {
    validateTeam(team);
    Queue<String> queue = new Queue<>();

    if (isTrivialElimination(team)) {
      queue.enqueue(tempWinner);
      return queue;
    }

    FlowNetwork network = getFlowNetwork(team);
    FordFulkerson ff = getFordFulkerson(network);
    for (FlowEdge edge : network.adj(SOURCE))
      if (edge.flow() < edge.capacity())
        for (String s : teams) {
          int teamVertex = getTeamVertex(teamIndex.get(s));
          if (ff.inCut(teamVertex)) queue.enqueue(s);
        }
    return queue.isEmpty() ? null : queue;
  }

  // validate team
  private void validateTeam(String team) {
    if (team == null) throw new IllegalArgumentException();
    if (!teamIndex.containsKey(team)) throw new IllegalArgumentException();
  }

  public static void main(String[] args) {
    BaseballElimination division = new BaseballElimination(args[0]);
    for (String team : division.teams()) {
      if (division.isEliminated(team)) {
        StdOut.print(team + " is eliminated by the subset R = { ");
        for (String t : division.certificateOfElimination(team)) {
          StdOut.print(t + " ");
        }
        StdOut.println("}");
      }
      else {
        StdOut.println(team + " is not eliminated");
      }
    }
  }
}
