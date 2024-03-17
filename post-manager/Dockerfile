# Use an Ubuntu image
FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y curl &&\
    apt install -y xdg-utils

# Install OpenJDK, AWS CLI, and LocalStack dependencies
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk curl python3 python3-pip groff less zip iputils-ping 

# Install AWS CLI using pip3
RUN pip3 install --upgrade awscli
RUN pip3 install awscli-local

# Optional: Set the environment variable for the app directory
ENV APP_HOME=/usr/app

# Set the working directory inside the container
WORKDIR $APP_HOME/

# Copy the compiled JAR into the image
COPY ./post-manager/target/postmanager-0.0.1-SNAPSHOT.jar $APP_HOME/app.jar

# Expose port 8081 (if your application requires it)
EXPOSE 8081

# Command to run the application
CMD ["java", "-jar", "app.jar"]
