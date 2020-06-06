CREATE TABLE Users(
	Id BIGINT PRIMARY KEY IDENTITY,
	Username CHAR (30) NOT NULL,
	[Password] CHAR (26) NOT NULL,
	ProfilePicture VARBINARY CHECK (DATALENGTH(ProfilePicture) <= 900 * 1024),
	LastLoginTime DATETIME2,
	IsDeleted BIT NOT NULL
	)

INSERT INTO Users(Username, [Password], IsDeleted)
	VALUES
			('Puhi', '1234SudhG', 0),
			('Zhizha', '1Ef4SuJK', 0),
			('Ivo', 'dshaDEWJ', 0),
			('Ocho', '123KFd4566wDdfg', 1),
			('Meca', 'dfga%^$wfgmo', 0)

ALTER TABLE Users
DROP CONSTRAINT [PK__Users__3214EC07D931ACB0]

ALTER TABLE Users
ADD CONSTRAINT PK__Users__CompositeIdUsername
PRIMARY KEY (Id, Username)

ALTER TABLE Users
ADD CONSTRAINT MIN_PASSWORD_LENGTH
CHECK (LEN([Password]) >= 5)

ALTER TABLE Users
ADD CONSTRAINT DEFAULT_LAST_LOGIN
DEFAULT GETDATE() FOR LastLoginTime

ALTER TABLE Users
DROP CONSTRAINT PK__Users__CompositeIdUsername

ALTER TABLE Users
ADD CONSTRAINT PK__Users__CompositeId
PRIMARY KEY(Id)

ALTER TABLE Users
ADD CONSTRAINT UNIQUE_USERNAME
UNIQUE(Username)

ALTER TABLE Users
ADD CONSTRAINT MIN_USERNAME_LENGTH
CHECK(LEN(Username) >= 3)