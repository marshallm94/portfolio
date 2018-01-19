from sys import exit

class Board():
    """
    The Board class keeps track of the state of the board when a game of
    tic-tac-toe is instantiated. It has methods to check if a player's entry
    is valid, check if there is a winner/tie and finally a method to update the
    board after a player has selected a space to play.

    Attributes:
        board_size: (int) The size of the board. This number will determine the
                    number of rows and columns that the board has (the board
                    will always be a square). Default value = 3.
        board_data: (list) A list of list's of tuples, created by referencing
                    the board_size attribute.
    """

    def __init__(self, board_size=3):
        self.board_size = board_size
        self.board_data = [[(row, column) for column in range(board_size)] for row in range(board_size)]

    def check_win(self, marker):
        """
        Checks to see if there is a winner.

        Input:
            marker: (str) The marker to use to check if there is a winner
        Output:
            True or False
        """
        # row check
        for row in self.board_data:
            check = [i for i in row]
            if check.count(marker) == self.board_size:
                return True
        # column check
        for i in range(self.board_size):
            length = self.board_size - 1
            check = []
            while length >= 0:
                check.append(self.board_data[length][i])
                length -= 1
            if check.count(marker) == self.board_size:
                return True
        # left diagonal check
        check = []
        for i in range(self.board_size):
            check.append(self.board_data[i][i])
        if check.count(marker) == self.board_size:
            return True
        # right diagonal check
        check = []
        length = self.board_size - 1
        while length >= 0:
            for row in self.board_data:
                check.append(row[length])
                length -= 1
        if check.count(marker) == self.board_size:
            return True
        else:
            return False

    def check_validity(self, coord_1, coord_2):
        """
        Check to see if a coordinate on the board is available for a user to
        play at.

        Input:
            coord_1: (int) The "row" number of the board to look in.
            coord_2: (int) The "column" number of the board to look in.
        Output:
            True or False
        """
        if type(self.board_data[coord_1][coord_2]) == str:
            print("\n\tLooks like that spot is already taken. Try again.")
            return False
        else:
            return True

    def check_tie(self):
        """
        Check to see if there is tie game.

        Input:
            None
        Output:
            True or False
        """
        check = 0
        for i in self.board_data:
            for j in i:
                if type(j) == tuple:
                    return False
        return True

    def update_board(self, coord_1, coord_2, marker):
        """
        Update the board after a player has chosen the place they would like to
        play.

        Input:
            coord_1: (int) The "row" number of the board to look in.
            coord_2: (int) The "column" number of the board to look in.
            marker: (str) The marker of the player to put at coord_1, coord_2
        """
        self.board_data[coord_1][coord_2] = marker
        return self.board_data

    def __repr__(self):
        """
        Prints the board in a "pretty" way.
        """
        out = "\n\t  "
        for i in range(0, self.board_size):
            if i == self.board_size - 1:
                string = "  " + str(i) + "   "
            else:
                string = "  " + str(i) + "  " + "|"
            out += string
        for i in range(0, self.board_size):
            out += "\n\n\t"
            string = str(i) + " "
            for j in range(0, self.board_size):
                if j == self.board_size - 1:
                    if type(self.board_data[i][j]) == tuple:
                        string += "_" * 5 + ""
                    elif type(self.board_data[i][j]) == str:
                        string += " " + str(self.board_data[i][j]) + " "
                else:
                    if type(self.board_data[i][j]) == tuple:
                        string += "_" * 5 + "|"
                    elif type(self.board_data[i][j]) == str:
                        string += " " + str(self.board_data[i][j]) + " |"
            out += string
        return out

class Player():
    """
    The Player class keeps track of three attributes for each player.

    Attributes:
        name: (str) The name of the player.
        marker: (str) The marker that the player will use. (e.g "X" or "O")
        wins: (int) The number of wins the player has. (0 upon instantiation)
    """

    def __init__(self, name, marker):
        self.name = name
        self.marker = marker
        self.wins = 0

    def __repr__(self):
        """
        Return the player info such that a call could be used to instantiate
        another player with the same attribute values.
        """
        return f"{self.__class__.__name__}('{self.name}', '{self.marker}')"

    def __str__(self):
        """
        Prints the player info in a "pretty" manner.
        """
        return f"\nClass: {self.__class__.__name__}\nName: {self.name}\nMarker: {self.marker}"

class Game():
    """
    The Game class contains all the logic for playing a game of tic-tac-toe.
    Upon instantiation, a board is instantiated using the _instantiate_board()
    method, two players are instantiated using the _create_players_list() method
    and the game is initialized using the _play_game() method.

    Attributes:
        players: (list) A list containing two instances of the Player class.
        ties: (int) The number of games that ended in a tie.
        board: (Board) An instance of the Board class. Default size = 3.
    """

    def __init__(self, board_size=3):
        self.players = []
        self.ties = 0
        self.board = self._initialize_board(board_size)
        self._create_players_list()
        self._play_game()

    def _scoreboard(self):
        """
        Prints the scoreboard in a "pretty" manner.
        """
        out = "\n\tScoreboard\n\t"
        for player in self.players:
            wins = player.name + ": " + str(player.wins) + "\n\t"
            out += wins
        out += "Ties: " + str(self.ties) + "\n"
        return out

    def _is_acceptable(self, user_input, board):
        """
        Checks if a users input is acceptable given the size of the board and if
        their input is in an acceptable format.

        Input:
            user_input: (str) The string entered by the user.
            board: (Board) The instance of the Board class to use to check the
                   user_input against.
        Output:
            True or False
        """
        acceptable = [f"{i}" for i in range(0, board.board_size)]
        acceptable.append(",")
        if "," not in user_input:
            print("\v\tRemember to have your coordinates separated by a comma.")
            return False
        test = user_input.split(",")
        for element in test:
            if element not in acceptable:
                print("\n\tEntry not on board. Please try again.")
                return False
        return True

    def _create_coordinates(self, user_input):
        """
        Creates coordinates to based on a users input.

        Input:
            user_input: (str)
        Output:
            coord_1: (int) The "row" number of the board..
            coord_2: (int) The "column" number of the board.
        """
        coords = user_input.split(",")
        coord_1 = int(coords[0])
        coord_2 = int(coords[1])
        return coord_1, coord_2

    def _initialize_player(self, player_name, player_marker):
        """
        Creates an instance of the Player class.

        Input:
            player_name: (str)
            player_marker: (str)
        Output:
            An instance of the Player class.
        """
        player_marker.strip()
        player_marker = player_marker.capitalize()
        player_marker = " " + player_marker + " "
        player_name = player_name.casefold()
        player_name = player_name.capitalize()
        x = Player(player_name, player_marker)
        return x

    def _is_unique(self, test, message):
        """
        Ensures that the two players can't use the same name or marker.

        Input:
            test: (str) A user's input, which will be either their desired name
                  or marker.
            message: (str) A word (which will be either "name" or "marker") to
                     be used in the message displayed to the user if their test
                     entry is already taken.
        Output:
            True or False
        """
        check = []
        for player in self.players:
            name = player.name
            name = (name.casefold()).strip()
            marker = player.marker
            marker = (marker.casefold()).strip()
            check.append(name)
            check.append(marker)
        if test in check:
            print(f"\n\tUh oh, looks like '{test}' is already taken. Please choose another {message}.")
            return False
        else:
            return True

    def _create_players_list(self):
        """
        Create a list of two instances of the Player class for the game.
        """
        for i in range(1, 3):
            unique_name = False
            while not unique_name:
                user_input_1 = input(f"\n\tWhat name will player {i} go by? ")
                unique_name = self._is_unique(user_input_1, "name")
            unique_marker = False
            while not unique_marker:
                user_input_2 = input(f"\n\tAnd what marker would you like to use {user_input_1}? ")
                unique_marker = self._is_unique(user_input_2, "marker")
            player = self._initialize_player(user_input_1, user_input_2)
            self.players.append(player)

    def _initialize_board(self, board_size):
        """
        Creates an instance of the Board class for the game to use.

        Input:
            board_size: (int)
        Output:
            An instance of the Board class.
        """
        return Board(board_size)

    def _play_game(self):
        """
        The logic for playing a game of tic-tac-toe.
        """
        win = False
        tie = False
        while not win and not tie:
            for player_set in self.players:
                name = player_set.name
                marker = player_set.marker
                valid = False
                while not valid:
                    acceptable = False
                    while not acceptable:
                        print(f"\n\tAlright {name}, it's your turn...")
                        print(self.board)
                        user_input = input("\n\tWhere would you like to play? ").strip()
                        acceptable = self._is_acceptable(user_input, board=self.board)
                    coord_1, coord_2 = self._create_coordinates(user_input)
                    valid = self.board.check_validity(coord_1, coord_2)
                self.board.update_board(coord_1, coord_2, marker)
                if self.board.check_win(marker) == True:
                    break
                if self.board.check_tie() == True:
                    break
            win = self.board.check_win(marker)
            tie = self.board.check_tie()
        print(self.board)
        if tie == True:
            print("\n\tTie game!")
            self.ties += 1
        elif win == True:
            print(f"\n\t{name} won!")
            player_set.wins += 1
        quit = input("\n\tWould you like to play again? (yes/no) ").lower()
        if quit == "no":
            print(self._scoreboard())
            exit
        else:
            print(self._scoreboard())
            user_input = int(input("\tWhat size board would you like to play on? "))
            self.board = self._initialize_board(user_input)
            self._play_game()

Game()
