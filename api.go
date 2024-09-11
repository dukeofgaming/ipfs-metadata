package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jmoiron/sqlx"
)

func startAPI(db *sqlx.DB) {
	router := gin.Default()

	router.GET("/metadata", func(c *gin.Context) {
		metadata, err := getAllMetadata(db)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, metadata)
	})

	router.GET("/metadata/:cid", func(c *gin.Context) {
		cid := c.Param("cid")
		metadata, err := getMetadataByCID(db, cid)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, metadata)
	})

	router.GET("/healthcheck", func(c *gin.Context) {
		err := db.Ping()
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Database is unreachable"})
			return
		}
		c.JSON(http.StatusOK, gin.H{"message": "Everything is healthy!"})
	})
	
	router.Run(":8080")
}
