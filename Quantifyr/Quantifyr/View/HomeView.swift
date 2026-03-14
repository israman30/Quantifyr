//
//  HomeView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Scientific Toolkit")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    
                    Text("Enter known values → get results instantly")
                        .font(.subheadline)
                        .foregroundStyle(.tertiary)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 8)
                    
                    VStack(spacing: 12) {
                        NavigationLink {
                            UnitConverterView()
                        } label: {
                            FeatureCard(
                                title: "Unit Converter",
                                subtitle: "Length, weight, temperature, speed, energy",
                                icon: "arrow.left.arrow.right"
                            )
                        }
                        .buttonStyle(.plain)
                        
                        NavigationLink {
                            ElectricalView()
                        } label: {
                            FeatureCard(
                                title: "Electrical",
                                subtitle: "Ohm's Law, Power, Resistors, Capacitance",
                                icon: "bolt.fill"
                            )
                        }
                        .buttonStyle(.plain)
                        
                        NavigationLink {
                            FrequencyView()
                        } label: {
                            FeatureCard(
                                title: "Frequency & Signal",
                                subtitle: "Wavelength, RC filter",
                                icon: "waveform"
                            )
                        }
                        .buttonStyle(.plain)
                        
                        NavigationLink {
                            PhysicsView()
                        } label: {
                            FeatureCard(
                                title: "Physics",
                                subtitle: "Force, Kinetic Energy, Momentum",
                                icon: "atom"
                            )
                        }
                        .buttonStyle(.plain)
                        
                        NavigationLink {
                            MetricPrefixView()
                        } label: {
                            FeatureCard(
                                title: "Metric Prefix",
                                subtitle: "kilo, mega, giga, milli, micro, nano",
                                icon: "number"
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Quantifyr")
        }
    }
}

#Preview {
    HomeView()
}

struct FeatureCard: View {
    let title: String
    var subtitle: String? = nil
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.primary)
                .frame(width: 44, height: 44)
                .background(.primary.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
