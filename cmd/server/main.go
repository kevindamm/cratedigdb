package main

import (
	"github.com/gin-gonic/gin"
	"github.com/kevindamm/cratedig/service"
)

func main() {
	router := gin.Default()
	service.DefineRoutes(router)
	router.Run("localhost:8080")
}
