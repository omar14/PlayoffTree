# PlayoffTree

A simple way to generate a playoff tree for a tournament

## Notes

### UI Structure

Basically the tree consist of two main UIKit classes, UICollectionView to hold rounds view with horizontal scrolling and paging enabled. Each cell of
the UICollectionView contains a UITableView to view the list of matches with vertical scrolling. This will give you the flexibility to manage each round
if you want something different for the final for example.

### UIScrollView vs UICollectionView

At first I thought about UIScrollView to hold the main view, but as of apple documentation UICollectionView is more suited for this
project since it gives me more control and flexibilty for dynamically changing the layout for design enhancements.

### Dictionary vs Array

I had two options to store the matches before display, either store them in a dictionary of [Int:[Match]] where Int is the
Round number and [Match] is the array of matches for each Round, the other option would be storing all matches in a single
array and access them through the index number of the match. Since both have nearly O(1) when it comes to accessing the value I went with Array because the order is important in my case.

### Full Tree

The assumption here is this is a full tree so it grows by power of 2 so that the winner of a match will find an opponent.


## Initialaization

### Array of mtches
```
let myMatches = [Match(title: "Match1", homeTeam: "LEC", awayTeam: "ARS"), Match(title: "Match2", homeTeam: "BRC", awayTeam: "MAL"), Match(title: "Match3", homeTeam: "DOR", awayTeam: "FCB")]

PlayOffTree(treeMatches: matchesArray)
```
Generate the tree using the array of matches, useful when you recieve the matches data (JSON for example)

### Number of Rounds
```
PlayOffTree(numberOfRounds: number)
```
Generate the tree with number of tournament rounds

### Number of Teams
```
PlayOffTree(numberOfTeams: number)
```
Generate the tree with the number of teams participating in the tournament

### Number of Matches
```
PlayOffTree(numberOfMatches: number)
```
Generate the tree with total number of matches

