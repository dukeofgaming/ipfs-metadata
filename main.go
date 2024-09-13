package main

import (
	"log"
	"flag"
	"os"
)

func main() {
	healthcheck := flag.Bool("healthcheck", false, "Perform a health check")
    flag.Parse()

	db, err := setupDB()
	if err != nil {
		
		if *healthcheck {
            log.Printf("Health check failed: %v", err)
        }

		log.Fatal(err)
	}

	if *healthcheck {
        log.Println("Health check passed!")
        os.Exit(0)
    }

	cids, err := readCSV("data/ipfs_cids.csv")
	if err != nil {
		log.Fatal(err)
	}

	for _, cid := range cids {
		metadata, err := fetchMetadata(cid)
		if err != nil {
			log.Printf("Failed to fetch metadata for CID %s: %v", cid, err)
			continue
		}
		err = insertMetadata(db, cid, metadata)
		if err != nil {
			log.Printf("Failed to insert metadata for CID %s: %v", cid, err)
		}
	}

	startAPI(db)
}
