-- --------------------------------------------------------
-- Host:                         consensuspkidbhost
-- Server version:               10.3.10-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             9.5.0.5196
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for consensuspki
CREATE DATABASE IF NOT EXISTS `consensuspki` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `consensuspki`;

-- Dumping structure for table consensuspki.ca_certificateblockchain
CREATE TABLE IF NOT EXISTS `ca_certificateblockchain` (
  `Year` int(11) NOT NULL,
  `Height` int(11) NOT NULL,
  `PreviousBlockHeader` varchar(512) NOT NULL,
  `BlockHeader` varchar(512) NOT NULL,
  `CACertificate` longtext NOT NULL,
  `MerkleRoot` varchar(512) NOT NULL,
  `Nonce` int(11) NOT NULL,
  `BlockTimestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  KEY `Height` (`Height`),
  KEY `PreviousBlockHeader` (`PreviousBlockHeader`),
  KEY `BlockHeader` (`BlockHeader`),
  KEY `MerkleRoot` (`MerkleRoot`),
  KEY `Year` (`Year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table consensuspki.ca_evidenceblockchain
CREATE TABLE IF NOT EXISTS `ca_evidenceblockchain` (
  `EvidenceBlockChainID` varchar(512) NOT NULL,
  `Height` int(11) NOT NULL,
  `PreviousBlockHeader` varchar(512) NOT NULL,
  `BlockHeader` varchar(512) NOT NULL,
  `Evidence` longtext NOT NULL,
  `Nonce` int(11) NOT NULL,
  `BlockTimestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  KEY `Height` (`Height`),
  KEY `PreviousBlockHeader` (`PreviousBlockHeader`),
  KEY `BlockHeader` (`BlockHeader`),
  KEY `EvidenceBlockChainID` (`EvidenceBlockChainID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table consensuspki.ca_rootblockchain
CREATE TABLE IF NOT EXISTS `ca_rootblockchain` (
  `Height` int(11) NOT NULL,
  `PreviousBlockHeader` varchar(512) NOT NULL,
  `Link` VARCHAR(512) NOT NULL,
  `BlockHeader` varchar(512) NOT NULL,
  `MerkleRoot` varchar(512) NOT NULL,
  `Nonce` varchar(512) NOT NULL,
  `BlockTimestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  KEY `Height` (`Height`),
  KEY `PreviousBlockHeader` (`PreviousBlockHeader`),
  KEY `BlockHeader` (`BlockHeader`),
  KEY `MerkleRoot` (`MerkleRoot`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table consensuspki.ca_subjects
CREATE TABLE IF NOT EXISTS `ca_subjects` (
  `YEAR` int(11) NOT NULL,
  `HEIGHT` int(11) NOT NULL,
  `SUBJECT` varchar(512) NOT NULL,
  KEY `YEAR` (`YEAR`),
  KEY `HEIGHT` (`HEIGHT`),
  KEY `SUBJECT` (`SUBJECT`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table consensuspki.certificateblockchain
CREATE TABLE IF NOT EXISTS `certificateblockchain` (
  `Year` int(11) NOT NULL,
  `Height` int(11) NOT NULL,
  `PreviousBlockHeader` varchar(512) NOT NULL,
  `BlockHeader` varchar(512) NOT NULL,
  `MerkleRoot` varchar(512) NOT NULL,
  `Nonce` int(11) NOT NULL,
  `BlockTimestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  KEY `Height` (`Height`),
  KEY `PreviousBlockHeader` (`PreviousBlockHeader`),
  KEY `BlockHeader` (`BlockHeader`),
  KEY `MerkleRoot` (`MerkleRoot`),
  KEY `Year` (`Year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table consensuspki.evidenceblockchain
CREATE TABLE IF NOT EXISTS `evidenceblockchain` (
  `EvidenceBlockChainID` varchar(512) NOT NULL,
  `Height` int(11) NOT NULL,
  `PreviousBlockHeader` varchar(512) NOT NULL,
  `BlockHeader` varchar(512) NOT NULL,
  `Evidence` longtext NOT NULL,
  `Nonce` int(11) NOT NULL,
  `BlockTimestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  KEY `Height` (`Height`),
  KEY `PreviousBlockHeader` (`PreviousBlockHeader`),
  KEY `BlockHeader` (`BlockHeader`),
  KEY `EvidenceBlockChainID` (`EvidenceBlockChainID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for function consensuspki.GetOrderedCASubjects
DELIMITER //
CREATE DEFINER=`root`@`%` FUNCTION `GetOrderedCASubjects`(
	`p_year` INT,
	`p_height` INT
) RETURNS longtext CHARSET utf8
    DETERMINISTIC
BEGIN
DECLARE OrderedCASubjects LONGTEXT;
  SET OrderedCASubjects = '';
  Select GROUP_CONCAT(s.SUBJECT ORDER BY s.SUBJECT SEPARATOR '' ) into OrderedCASubjects
	from ca_certificateblockchain c, ca_subjects  s
	WHERE s.YEAR = c.Year AND c.Height = s.HEIGHT
	and c.Year = p_year and c.Height = p_height
	GROUP BY c.Year , c.Height  ORDER BY c.Year,c.Height;
  RETURN OrderedCASubjects;
END//
DELIMITER ;

-- Dumping structure for function consensuspki.GetOrderedSubjects
DELIMITER //
CREATE DEFINER=`root`@`%` FUNCTION `GetOrderedSubjects`(
	`p_year` INT,
	`p_height` INT
) RETURNS longtext CHARSET utf8
    DETERMINISTIC
BEGIN
DECLARE OrderedSubjects LONGTEXT;
  SET OrderedSubjects = '';
  Select GROUP_CONCAT(s.SUBJECT ORDER BY s.SUBJECT SEPARATOR '' ) into OrderedSubjects
	from certificateblockchain c, subjects  s
	WHERE s.YEAR = c.Year AND c.Height = s.HEIGHT
	and c.Year = p_year and c.Height = p_height
	GROUP BY c.Year , c.Height  ORDER BY c.Year,c.Height;
  RETURN OrderedSubjects;
END//
DELIMITER ;

-- Dumping structure for procedure consensuspki.PoWCACertificateBlockchain
DELIMITER //
CREATE DEFINER=`root`@`%` PROCEDURE `PoWCACertificateBlockchain`(
	IN `p_year` INT,
	IN `p_height` INT,
	OUT `p_Nonce` INT,
	OUT `p_BlockTimestamp` TIMESTAMP,
	OUT `p_BlockHeader` VARCHAR(512)







)
BEGIN
DECLARE myNonce INT;
DECLARE myBlockTimestamp TIMESTAMP;
DECLARE myBlockHeader varchar(512);

SET myNonce = 0;

REPEAT

SET myBlockTimestamp = current_timestamp;
SET myNonce = myNonce + 1;
select SHA2(concat(hex(PreviousBlockHeader),hex(SHA2(CACertificate,256)),hex(MerkleRoot),myNonce,myBlockTimestamp,year,height,GetOrderedCASubjects(Year,Height)),256)   into myBlockHeader
from ca_certificateblockchain
where year = p_year
and height = p_height;

UNTIL substr(myBlockHeader,1,3) = '000'

END REPEAT;

set p_Nonce = myNonce;
set p_BlockTimestamp = myBlockTimestamp;
set p_BlockHeader = myBlockHeader;


END//
DELIMITER ;

-- Dumping structure for procedure consensuspki.PoWCertificateBlockchain
DELIMITER //
CREATE DEFINER=`root`@`%` PROCEDURE `PoWCertificateBlockchain`(
	IN `p_year` INT,
	IN `p_height` INT,
	OUT `p_Nonce` INT,
	OUT `p_BlockTimestamp` TIMESTAMP,
	OUT `p_BlockHeader` VARCHAR(512)



)
BEGIN
DECLARE myNonce INT;
DECLARE myBlockTimestamp TIMESTAMP;
DECLARE myBlockHeader varchar(512);

SET myNonce = 0;

REPEAT

SET myBlockTimestamp = current_timestamp;
SET myNonce = myNonce + 1;
select sha2(concat(hex(PreviousBlockHeader),hex(MerkleRoot),myNonce,myBlockTimestamp,Year,Height,GetOrderedSubjects(Year,Height)),256)  into myBlockHeader
from certificateblockchain
where year = p_year
and height = p_height;

UNTIL substr(myBlockHeader,1,3) = '000'

END REPEAT;

set p_Nonce = myNonce;
set p_BlockTimestamp = myBlockTimestamp;
set p_BlockHeader = myBlockHeader;


END//
DELIMITER ;

-- Dumping structure for table consensuspki.rootblockchain
CREATE TABLE IF NOT EXISTS `rootblockchain` (
  `Height` int(11) NOT NULL,
  `PreviousBlockHeader` varchar(512) NOT NULL,
  `Link` VARCHAR(512) NOT NULL,
  `BlockHeader` varchar(512) NOT NULL,
  `MerkleRoot` varchar(512) NOT NULL,
  `Nonce` varchar(512) NOT NULL,
  `BlockTimestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  KEY `Height` (`Height`),
  KEY `PreviousBlockHeader` (`PreviousBlockHeader`),
  KEY `BlockHeader` (`BlockHeader`),
  KEY `MerkleRoot` (`MerkleRoot`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table consensuspki.subjects
CREATE TABLE IF NOT EXISTS `subjects` (
  `YEAR` int(11) NOT NULL,
  `HEIGHT` int(11) NOT NULL,
  `SUBJECT` varchar(512) NOT NULL,
  KEY `YEAR` (`YEAR`),
  KEY `HEIGHT` (`HEIGHT`),
  KEY `SUBJECT` (`SUBJECT`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for view consensuspki.vw_ca
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `vw_ca` (
	`SUBJECT` VARCHAR(512) NOT NULL COLLATE 'utf8_general_ci',
	`CACertificate` LONGTEXT NOT NULL COLLATE 'utf8_general_ci'
) ENGINE=MyISAM;

-- Dumping structure for view consensuspki.vw_response
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `vw_response` (
	`SUBJECT` VARCHAR(512) NOT NULL COLLATE 'utf8_general_ci',
	`Hash` VARCHAR(64) NULL COLLATE 'utf8mb4_general_ci'
) ENGINE=MyISAM;

-- Dumping structure for view consensuspki.vw_ca
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `vw_ca`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_ca` AS select ca_subjects.SUBJECT,ca_certificateblockchain.CACertificate  from ca_certificateblockchain,ca_subjects
where ca_certificateblockchain.Year = ca_subjects.year and ca_certificateblockchain.Height =ca_subjects.height
order by ca_certificateblockchain.year desc ,ca_certificateblockchain.height desc ;

-- Dumping structure for view consensuspki.vw_response
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `vw_response`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_response` AS select subjects.SUBJECT, upper(sha2(concat(hex(subjects.SUBJECT), hex(certificateblockchain.MerkleRoot)),256)) Hash from subjects, certificateblockchain where subjects.YEAR = certificateblockchain.Year and subjects.HEIGHT = certificateblockchain.Height  order by certificateblockchain.year desc, certificateblockchain.height desc ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
