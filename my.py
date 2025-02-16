Algorithm 6.1: Online Workload Prediction

Input: Historical metrics H, Current metrics C, Window size W
Output: Predicted resource requirements P

1. Initialize sliding window SW of size W
2. For each new metric set M in C:
    3. Add M to SW
    4. If SW.size > W:
        5. Remove oldest entry
    6. features = ExtractFeatures(SW)
    7. P = PredictResources(features)
    8. UpdateModel(P, ActualUsage)
9. Return P


Algorithm 6.2: Hybrid Resource Prediction

Input: Current metrics M, Historical data H
Output: Resource prediction P

1. Initialize weights w1, w2, for each model
2. Get prediction P1 from pre-trained model
3. Get prediction P2 from online model
4. Calculate confidence scores C1, C2
5. Update weights based on confidence:
    w1 = C1 / (C1 + C2)
    w2 = C2 / (C1 + C2)
6. Return weighted prediction:
    P = w1 * P1 + w2 * P2
    
    
    
Algorithm 6.3: Resource Priority Calculation

Input: Service S, Dependency Graph G
Output: Resource Priority P

1. Initialize P = 1.0
2. Queue Q = [S]
3. Visited = {}
4. While Q is not empty:
    5. Current = Q.dequeue()
    6. If Current in Visited:
        7. Continue
    8. Add Current to Visited
    9. P += Current.Criticality * DepthWeight
    10. For each dependent in Current.Dependents:
        11. Q.enqueue(dependent)
12. Return P


Algorithm 6.5: DQN Training for Resource Scaling

Input: Initial state S, Action space A, Learning rate alpha
Output: Trained DQN model

1. Initialize DQN with random weights 0
2. Initialize target network with weights 0' = 0
3. Initialize replay buffer D
4. For episode = 1 to M:
    5. Observe initial state s
    6. For t = 1 to T:
        7. With probability epsilon select random action at
            Otherwise select at = argmax Q(st, a; 0)
        8. Execute action at, observe reward rt and next state st+1
        9. Store transition (st, at, rt, st+1) in D
        10. Sample random minibatch of transitions from D
        11. Set yi = ri + gamma maxa' Q(si+1, a'; 0')
        12. Perform gradient descent step on (yi - Q(si, ai; 0))^(2)
        13. Every C steps set 0' = 0



