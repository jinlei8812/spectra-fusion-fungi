function similarity = cosine_similarity(vec1, vec2)
    % º∆À„”‡œ“œ‡À∆∂»
    similarity = dot(vec1, vec2) / (norm(vec1) * norm(vec2));
end
